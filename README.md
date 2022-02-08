# NetworkCTI
Arkime, Suricata, Logstash 3개의 Container로 구성되어 있는 네트워크 분석 환경입니다. 

# docker & docker-compose version
* 실행했던 환경은 ubuntu 18.04 LTS에서 실행했습니다.
* docker 버전이 너무 낮다면 업그레이드를 해야 합니다. docker-compose.yml의 버전은 '3.7'을 사용하고 있습니다. 
*  docker 상위 버전을 설치하는 방법은 아래 링크를 참고합니다.
https://kangwoo.kr/2020/07/25/%EC%9A%B0%EB%B6%84%ED%88%AC%EC%97%90-docker-%EC%84%A4%EC%B9%98%ED%95%98%EA%B8%B0/
* 아래 코드는 높은 docker-compose 버전을 설치하는 과정입니다. 
<pre>
$ sudo apt-get remove docker-compose
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
$ sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
</pre>

# 설치 및 실행 순서

1. vm.max_map_count
<pre>$sudo sysctl -w vm.max_map_count=262144</pre>
호스트 vm.max_map_count를 바꿉니다.

# 주의 사항
* docker 버전과 docker-compose 버전을 맞추기 위해 기존에 사용하시던 docker를 삭제해주시기 바랍니다.


