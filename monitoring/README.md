# Install Prometheus 
```
docker run --privileged -it --rm --network host -v ${PWD}/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml -v ${PWD}/prometheus/alerts/:/etc/prometheus/alerts/ quay.io/prometheus/prometheus:latest
```

# Install Alertmanager
# Install Blackbox
# Install NodeExporter
# Install Victoria Metrics
# Instal Grafana
# Install prom-msteam

