```
HOST=localhost
```
### Install Prometheus 
```
docker run  --rm -d --name prometheus --network host -v ${PWD}/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml -v ${PWD}/prometheus/alerts/:/etc/prometheus/alerts/ quay.io/prometheus/prometheus:latest
```
### Install Alertmanager
```
docker run --rm -d  --name alertmanager --network host -v ${PWD}/alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml quay.io/prometheus/alertmanager --config.file=/etc/alertmanager/alertmanager.yml --web.external-url http://$HOST:9093
```
### Install Blackbox
```
 docker run --rm -d --name blackboxExporter --network host  -v ${PWD}/blackbox-exporter/blackbox.yml:/config/blackbox.yml  quay.io/prometheus/blackbox-exporter:latest --config.file=/config/blackbox.yml

```

### Install NodeExporter
```
docker run --rm -d  --name nodeExporter --network host -v "/:/host:ro,rslave" quay.io/prometheus/node-exporter:latest --path.rootfs=/host --collector.textfile.directory=/tmp/

```
### Install prom-msteam
```
docker run --rm -d --name="promteams" --network host -v ${PWD}/promteams/config.yml:/tmp/config.yml -v ${PWD}/promteams/card.tmpl:/tmp/card.tmpl   -e CONFIG_FILE="/tmp/config.yml" -e TEMPLATE_FILE="/tmp/card.tmpl"  quay.io/prometheusmsteams/prometheus-msteams 
```

### Instal Grafana
```
docker run --rm -d --name="grafana" --network host grafana/grafana 
```

### Install Victoria Metrics
```
docker run -d --name="victoria-metrics" --network host --rm -v ${PWD}/victoria-metrics-data:/victoria-metrics-data victoriametrics/victoria-metrics

```
8428


