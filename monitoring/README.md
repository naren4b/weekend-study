### Set up an Ubuntu machine 
```
NAME="Ubuntu"
VERSION="21.04 (Hirsute Hippo)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 21.04"
VERSION_ID="21.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=hirsute
UBUNTU_CODENAME=hirsute
```
### Set up docker in it 
follow steps here : https://docs.docker.com/engine/install/ubuntu/
### Update your host details 

```
#update in etc file 
127.0.0.1 monitoring.demo.naren4biz.in
HOST=monitoring.demo.naren4biz.in 
```
### Install Prometheus 
http://monitoring.demo.naren4biz.in:9090
```
docker run  --rm -d --name prometheus --network host -v ${PWD}/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml -v ${PWD}/prometheus/alerts/:/etc/prometheus/alerts/ quay.io/prometheus/prometheus:v2.33.5
```
### Install Alertmanager
http://monitoring.demo.naren4biz.in:9093
```
docker run --rm -d  --name alertmanager --network host -v ${PWD}/alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml quay.io/prometheus/alertmanager:v0.23.0 --config.file=/etc/alertmanager/alertmanager.yml --web.external-url http://$HOST:9093
```
### Install Blackbox
http://monitoring.demo.naren4biz.in:9115
```
 docker run --rm -d --name blackboxExporter --network host  -v ${PWD}/blackbox-exporter/blackbox.yml:/config/blackbox.yml  quay.io/prometheus/blackbox-exporter:v0.19.0 --config.file=/config/blackbox.yml

```

### Install NodeExporter
http://monitoring.demo.naren4biz.in:9100
```
docker run --rm -d  --name nodeExporter --network host -v "/:/host:ro,rslave" quay.io/prometheus/node-exporter:v1.3.1 --path.rootfs=/host --collector.textfile.directory=/tmp/

```
### Install prom-msteam
http://monitoring.demo.naren4biz.in:2000
```
docker run --rm -d --name="promteams" --network host -v ${PWD}/promteams/config.yml:/tmp/config.yml -v ${PWD}/promteams/card.tmpl:/tmp/card.tmpl   -e CONFIG_FILE="/tmp/config.yml" -e TEMPLATE_FILE="/tmp/card.tmpl"  quay.io/prometheusmsteams/prometheus-msteams 
```

### Instal Grafana
http://monitoring.demo.naren4biz.in:3000
```
docker run --rm -d --name="grafana" --network host grafana/grafana:8.4.3 
```

### Install Victoria Metrics
http://monitoring.demo.naren4biz.in:8428
```
docker run -d --name="victoria-metrics" --network host --rm -v ${PWD}/victoria-metrics-data:/victoria-metrics-data victoriametrics/victoria-metrics:v1.74.0

```





