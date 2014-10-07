# CoreOS ELK


Building elasticsearch docker image:
```bash
# Build task
docker build -t chrisjenx/elasticsearch ./elasticsearch/
docker push chrisjenx/elasticsearch
# Run on the cluster
cd elasticsearch && fleetctl start elasticsearch@1.service
```

Building logstash docker image:
```bash
# Build task
docker build -t chrisjenx/elasticsearch ./elasticsearch/
docker push chrisjenx/elasticsearch
# Run on the cluster
cd elasticsearch && fleetctl start elasticsearch@1.service
```
