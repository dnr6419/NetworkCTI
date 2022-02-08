#!/bin/bash

su - elasticsearch -c "/usr/share/elasticsearch/bin/elasticsearch &"

while ! curl http://localhost:9200; do  
  >&2 echo "[+] elasticsearch is unavailable - sleeping"
  sleep 1
done

echo "[+] set the password"
echo -e 'y\nwsec@))!\nwsec@))!\nwsec@))!\nwsec@))!\nwsec@))!\nwsec@))!\nwsec@))!\nwsec@))!\nwsec@))!\nwsec@))!\nwsec@))!\nwsec@))!\n' | bash -c "/usr/share/elasticsearch/bin/elasticsearch-setup-passwords interactive"

while true; do
  echo "[+] elasticsearch is running"
  sleep 30000
done