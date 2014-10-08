# CoreOS ELK

Make sure you have installed `fleet`:

```bash
brew update & brew install fleetctl
```

# TODO
 - [ ] `user-data` for Vagrant cluster
 - [ ] `user-data` for Development cluster
 - [ ] `user-data` for Staging cluster
 - [ ] `user-data` for Production cluster
 - [ ] Ansible tasks to build & deploy containers

# Default ENV

These are set by default in the `Dockerfile`s.
They can be adjusted at run time in the `service` files by appending
`-e KEY=VALUE` in the run docker command.

 - PUBLIC_IPV4 0.0.0.0 (This should be set by the systemd unit)
 - PRIVATE_IPV4 0.0.0.0 (This should be set by the systemd unit)

# ETCD

All units will broadcast them selfs onto etcd cluster using the following
convention:
```bash
/services/{{service_name}}/{{service_name}}-{{instance}} 'SomeValue'
# E.g.
/services/elasticsearch/elasticsearch-0 {"host":"172.16.1.102","http_port":9200,"transport_port":9200}
```

# Elasticsearch

These unit's will auto find each other via zen unicast.
They add them selfs to etcd like so `/services/elasticsearch/elasticsearch-%i` "%i" being the instance name.
Each time a new unit is added to the cluster it will add the previous nodes to
the unicast hosts.
See [elasticsearch.yml](./elasticsearch/confd/templates/elasticserach.yml).

N.B. You can't start more instances than their are boxes in the cluster.

Building elasticsearch docker image and starting it in fleet:
```bash
# Build task
docker build -t chrisjenx/elasticsearch ./elasticsearch/
docker push chrisjenx/elasticsearch
# Run on the cluster
fleetctl start ./elasticsearch/systemd/elasticsearch@{0,1}.service
```
The simple regex "{0,1}" defines the instances to start.

# HAProxy

We use HAProxy to load balance between multiple units.

Building haproxy docker image and starting it in fleet:
```bash
# Build task
docker build -t chrisjenx/haproxy ./haproxy/
docker push chrisjenx/haproxy
# Run on the cluster
cd haproxy && fleetctl start haproxy.service
```

Building logstash docker image and starting it in fleet:
```bash
# Build task
docker build -t chrisjenx/logstash ./logstash/
docker push chrisjenx/logstash
# Run on the cluster
cd logstash && fleetctl start logstash.service
```
