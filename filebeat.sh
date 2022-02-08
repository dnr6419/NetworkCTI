#!/bin/sh

elasticsearch_host="elasticsearch"  
elasticsearch_port=9200

# Wait for the elasticsearch docker to be running
while ! curl http://$elasticsearch_host:$elasticsearch_port; do  
  >&2 echo "[+] elasticsearch is unavailable - sleeping"
  sleep 1
done

kibana_host="kibana"  
kibana_port=5601

# Wait for the kibana docker to be running
while ! curl http://kibana:$kibana_port/index; do  
  >&2 echo "[+] kibana is unavailable - sleeping"
  sleep 1
done

sleep 40

ip=$(nslookup elasticsearch | tr " " ";")
GET_st="${ip%%;honeynet_elasticsearch*}"
GET_ip="${GET_st#*Address;1:;}"

echo "[+] Finding the Elasticsearch IP : $GET_ip"

sed -i "s/elasticsearch:9200/$GET_ip:9200/g" /filebeat/filebeat.yml

echo "[+] filebeat enable module"
/filebeat/filebeat modules enable suricata

# wait for executing kibana



echo "[+] filebeat setup -e"
/filebeat/filebeat setup -e

echo "[+] filebeat -e"
/filebeat/filebeat -e
