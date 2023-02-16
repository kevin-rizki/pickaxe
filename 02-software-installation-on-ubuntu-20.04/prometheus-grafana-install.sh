#!/bin/bash

# Install Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.34.0/prometheus-2.34.0.linux-amd64.tar.gz
tar -xvf prometheus-2.34.0.linux-amd64.tar.gz
sudo mv prometheus-2.34.0.linux-amd64 /usr/local/bin/prometheus
sudo useradd --no-create-home --shell /bin/false prometheus
sudo chown -R prometheus:prometheus /usr/local/bin/prometheus
sudo cp /usr/local/bin/prometheus/prometheus.yml /etc/prometheus/prometheus.yml
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml
sudo sed -i 's/    - targets: \['localhost:9090'\]/    - targets: \['localhost:9090'\]\n      - targets: \['localhost:9100'\]/' /etc/prometheus/prometheus.yml
sudo wget -q https://raw.githubusercontent.com/prometheus/node_exporter/master/examples/systemd/node_exporter.service -O /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
sudo systemctl start prometheus
sudo systemctl enable prometheus

# Install Grafana
sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/oss/release/grafana_8.3.2_amd64.deb
sudo dpkg -i grafana_8.3.2_amd64.deb
sudo systemctl start grafana-server
sudo systemctl enable grafana-server