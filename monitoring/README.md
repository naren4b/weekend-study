HOST=localhost
# Install Prometheus 
```
docker run --name prometheus --rm -d --network host -v ${PWD}/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml -v ${PWD}/prometheus/alerts/:/etc/prometheus/alerts/ quay.io/prometheus/prometheus:latest
```
# Install Alertmanager
```
docker run --name alertmanager --rm -d --network host -v ${PWD}/alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml -d -p 9093:9093 quay.io/prometheus/alertmanager --config.file=/etc/alertmanager/alertmanager.yml --web.external-url http://$HOST:9093
```
# Install Blackbox
```
 docker run  --name blackbox_exporter --rm -d -p 9115:9115 -v ${PWD}/blackbox-exporter/blackbox.yml:/config/blackbox.yml  quay.io/prometheus/blackbox-exporter:latest --config.file=/config/blackbox.yml

```

# Install NodeExporter
# Install Victoria Metrics
# Instal Grafana
# Install prom-msteam


