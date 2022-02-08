<<<<<<< HEAD
# docker & docker-compose version
#### 실행했던 환경은 ubuntu 18.04 LTS에서 실행했습니다.
#### docker 버전이 너무 낮다면 업그레이드를 해야 합니다. docker-compose.yml의 버전은 '3.7'을 사용하고 있습니다. 
#### docker 상위 버전을 설치하는 방법은 아래 링크를 참고합니다.
https://kangwoo.kr/2020/07/25/%EC%9A%B0%EB%B6%84%ED%88%AC%EC%97%90-docker-%EC%84%A4%EC%B9%98%ED%95%98%EA%B8%B0/
#### 아래 코드는 높은 docker-compose 버전을 설치하는 과정입니다. 
=======
# NetworkCTI
Arkime, Suricata, Logstash 3개의 Container로 구성되어 있는 네트워크 분석 환경입니다. 

# docker & docker-compose version
* 실행했던 환경은 ubuntu 18.04 LTS에서 실행했습니다.
* docker 버전이 너무 낮다면 업그레이드를 해야 합니다. docker-compose.yml의 버전은 '3.7'을 사용하고 있습니다. 
*  docker 상위 버전을 설치하는 방법은 아래 링크를 참고합니다.
https://kangwoo.kr/2020/07/25/%EC%9A%B0%EB%B6%84%ED%88%AC%EC%97%90-docker-%EC%84%A4%EC%B9%98%ED%95%98%EA%B8%B0/
* 아래 코드는 높은 docker-compose 버전을 설치하는 과정입니다. 
>>>>>>> c2a6e7f6e785d8c518f232a01114aa320c985521
<pre>
$ sudo apt-get remove docker-compose
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
$ sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
</pre>

# 설치 및 실행 순서

<<<<<<< HEAD
#### 0. 공유 디렉토리 생성
<pre> mkdir -p data/log && mkdir rules </pre>

#### 1. Download the rules.zip & Put in the ./rules
보유하고 있는 suricata rule을 rules 파일에 넣습니다. 
suricata가 읽는 rule 파일의 이름은 suricata.yaml에서 수정 가능합니다. 

#### 2. vm.max_map_count
<pre>$sudo sysctl -w vm.max_map_count=262144</pre>
호스트 vm.max_map_count를 바꿉니다.

#### 3. Elasticsearch memory allocation
네트워크 포렌식을 사용할 경우, jvm.options의 내용을 변경합니다.
권장하는 옵션은 Xms20g 입니다. 
<pre> sed -i 's/## -Xms2g/Xms20g/g' jvm.options</pre>

#### 4. Elasticsearch, Filebeat, Kibana
<pre> docker-compose up </pre>
honeynet 구축을 위해 3개의 이미지를 빌드하고 실행합니다.
정상 실행까지 1분 이상 소요됩니다.

#### 5. Suricata
suricata를 실행합니다. 
<pre>
$docker pull jasonish/suricata:latest

$docker run --name=suricata -itd --rm --net=host \
    --cap-add=net_admin --cap-add=sys_nice \
    -v [절대 경로]/classification.config:/usr/local/etc/suricata/classification.config \
    -v [절대 경로]/reference.config:/usr/local/etc/suricata/reference.config \
    -v [절대 경로]/data/log:/var/log/suricata \
    -v [절대 경로]/suricata.yaml:/etc/suricata/suricata.yaml \
    -v [절대 경로]/rules:/usr/local/var/lib/suricata/rules \
jasonish/suricata:latest -i enp0s8 
</pre>

#### 6. moloch 설치 
moloch dockerfile을 빌드하고 실행합니다.
<pre>
$mkdir -p data/raw && cd moloch
$docker build . --tag moloch
$docker run --name=moloch -it -d --rm --net=host \
    --cap-add=net_admin --cap-add=sys_nice \
    -v [절대 경로]/moloch:/moloch \
    -v [절대 경로]/data/raw:/data/moloch/raw \
    -v [절대 경로]/data/moloch_log:/data/moloch/logs \
    moloch -i eno1
</pre>

# filebeat 에러 
###직접 docker exec으로 filebeat 컨테이너 안에 들어가서 에러를 해결해야 합니다. 

http://10.0.8.18/research-and-development/cert/honeynet

# 주의 사항
#### docker 버전과 docker-compose 버전을 맞추기 위해 기존에 사용하시던 docker를 삭제해주시기 바랍니다.
=======
1. vm.max_map_count<br>
호스트 vm.max_map_count를 바꿉니다.
<pre>$sudo sysctl -w vm.max_map_count=262144</pre>


2. NIC traffic 설정 <br>
네트워크 트래픽을 탐지하고 수집할 NIC를 설정합니다. (e.g enp9s0)<br>
2-1. moloch/dockerfile에서 NIC를 수정합니다. <br>
2-2. moloch/conf/config.ini 에서 NIC를 수정합니다. <br>

3. docker-compose build를 실행할 위치는 moloch/ 입니다. <br>
(상위 경로에 있는 dockerfile은 개발 중인 이미지입니다.)<br>
<pre>
$cd NetworkCTI/moloch && docker-compose build
</pre>

4. docker-compose up을 통해 컨테이너를 올립니다.<br>

5. suricata와 arkime(moloch)가 설치된 이미지에 들어가 moloch를 실행시킵니다. <br>
<pre>
docker exec -it -u root surich /bin/bash
# moloch_elastic 컨테이너에서 elasticsearch가 제대로 실행될 때까지 기다려야 합니다. 
/data/moloch/db/db.pl http://172.18.0.2:9200 init
/data/moloch/bin/moloch_add_user.sh admin admin "password" -admin
# moloch network traffic capture
/data/moloch/bin/moloch-capture -c /data/moloch/etc/config.ini >> /data/moloch/logs/capture.log 2>&1 &
cd /data/moloch/viewer && /data/moloch/bin/node /data/moloch/viewer/viewer.js -c /data/moloch/etc/config.ini >> /data/moloch/logs/viewer.log 2>&1 &
</pre>

5. Log. <br>

# 주의 사항
* docker 버전과 docker-compose 버전을 맞추기 위해 기존에 사용하시던 docker를 삭제해주시기 바랍니다.
>>>>>>> c2a6e7f6e785d8c518f232a01114aa320c985521


