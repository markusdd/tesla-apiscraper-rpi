docker build --build-arg VCS_REF=`git rev-parse --short HEAD` --build-arg BUILD_DATE=`date -u +”%Y-%m-%dT%H:%M:%SZ”` -t tesla-apiscraper-rpi .

cd
mkdir tesla-apiscraper-data
cd tesla-apiscraper-data
mkdir grafana
mkdir influx
wget https://raw.githubusercontent.com/lephisto/tesla-apiscraper/master/config.py.dist -o config.py
#now edit config.py to match your data
#if you are using selinux (and you should be...)
chcon -R --type container_file_t .
#launch container, this should ideally be used as a docker compose file
docker run -p 3000:3000 -v $PWD/config.py:/opt/tesla-apiscraper/config.py -v $PWD/influx:/var/lib/influxdb -v $PWD/grafana:/var/lib/grafana --name tesla  markusdd/tesla-apiscraper-rpi
