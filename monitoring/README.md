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
# Install NodeExporter
# Install Victoria Metrics
# Instal Grafana
# Install prom-msteam


