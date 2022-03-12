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
```
docker run  --rm -d --name prometheus --network host -v ${PWD}/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml -v ${PWD}/prometheus/alerts/:/etc/prometheus/alerts/ quay.io/prometheus/prometheus:v2.33.5
```
http://monitoring.demo.naren4biz.in:9090
### Install Alertmanager

```
docker run --rm -d  --name alertmanager --network host -v ${PWD}/alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml quay.io/prometheus/alertmanager:v0.23.0 --config.file=/etc/alertmanager/alertmanager.yml --web.external-url http://$HOST:9093
```
http://monitoring.demo.naren4biz.in:9093
### Install Blackbox

```
 docker run --rm -d --name blackboxExporter --network host  -v ${PWD}/blackbox-exporter/blackbox.yml:/config/blackbox.yml  quay.io/prometheus/blackbox-exporter:v0.19.0 --config.file=/config/blackbox.yml
```
http://monitoring.demo.naren4biz.in:9115

### Install NodeExporter

```
docker run --rm -d  --name nodeExporter --network host -v "/:/host:ro,rslave" quay.io/prometheus/node-exporter:v1.3.1 --path.rootfs=/host --collector.textfile.directory=/tmp/
```
http://monitoring.demo.naren4biz.in:9100
### Install prom-msteam

```
docker run --rm -d --name="promteams" --network host -v ${PWD}/promteams/config.yml:/tmp/config.yml -v ${PWD}/promteams/card.tmpl:/tmp/card.tmpl   -e CONFIG_FILE="/tmp/config.yml" -e TEMPLATE_FILE="/tmp/card.tmpl"  quay.io/prometheusmsteams/prometheus-msteams 
curl http://monitoring.demo.naren4biz.in:2000/config
```


### Instal Grafana

```
docker run --rm -d --name="grafana" --network host grafana/grafana:8.4.3 
```
http://monitoring.demo.naren4biz.in:3000


### Install Victoria Metrics

```
docker run -d --name="victoria-metrics" --network host --rm -v ${PWD}/victoria-metrics-data:/victoria-metrics-data victoriametrics/victoria-metrics:v1.74.0

```
http://monitoring.demo.naren4biz.in:8428/vmui

![image](https://user-images.githubusercontent.com/3488520/158003441-96c0e6e1-b272-4d5e-9388-a224d140dde0.png)




