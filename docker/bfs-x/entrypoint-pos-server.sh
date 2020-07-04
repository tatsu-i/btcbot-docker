#!/bin/bash
sed -i -e "s/__ACCESS_KEY__/$ACCESS_KEY/g" trade.yaml
sed -i -e "s/__SECLET_KEY__/$SECLET_KEY/g" trade.yaml
sed -i -e "s|__WEBHOOK_URL__|$WEBHOOK_URL|g" trade.yaml
/wait-for-it.sh influxdb:8086
sleep 5

python pos_server.py
