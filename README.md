# CoreOS ELK


Building elasticsearch docker image and starting it in fleet:
```bash
# Build task
docker build -t chrisjenx/elasticsearch ./elasticsearch/
docker push chrisjenx/elasticsearch
# Run on the cluster
cd elasticsearch && fleetctl start elasticsearch@0.service
```

Building logstash docker image and starting it in fleet:
```bash
# Build task
docker build -t chrisjenx/logstash ./logstash/
docker push chrisjenx/logstash
# Run on the cluster
cd logstash && fleetctl start logstash.service
```
