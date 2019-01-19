#!/bin/bash

if [ ! -f /opt/tesla-apiscraper ]; then
    cp /opt/tesla-apiscraper/config.py.dist /opt/tesla-apiscraper/config.py
    echo "No config file for tesla-apiscraper. Creating template and exiting!"
    exit
fi

influxd&
# this is safe as influx will not override if the datbase already exists
influx -execute "create database tesla"
cd /usr/share/grafana/
source /etc/default/grafana-server
/usr/sbin/grafana-server --config=${CONF_FILE} --pidfile=${PID_FILE_DIR}/grafana-server.pid --packaging=deb cfg:default.paths.logs=${LOG_DIR} cfg:default.paths.data=${DATA_DIR} cfg:default.paths.plugins=${PLUGINS_DIR} cfg:default.paths.provisioning=${PROVISIONING_CFG_DIR}&
cd /opt/tesla-apiscraper
python apiscraper.py
