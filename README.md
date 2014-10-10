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
/services/elasticsearch/elasticsearch-0 '{"IP":"172.16.1.102","HttpPort":9201,"TransportPort":9301}'
```

# Elasticsearch

These unit's will auto find each other via zen unicast.
They add them selfs to etcd like so `/services/elasticsearch/elasticsearch-%i` "%i" being the instance name.
Each time a new unit is added to the cluster it will add the previous nodes to
the unicast hosts.
See [elasticsearch.yml](./elasticsearch/confd/templates/elasticserach.yml).

TODO:
 - [ ] Build a discovery service that will only broadcast the Elasticsearch box once its "avaliable"
 - [ ] Define meta data so that they only run on specified boxes so they will pick up there exisiting data stores.

**Building elasticsearch docker image and starting it in fleet:**
```bash
# Build task
docker build -t chrisjenx/elasticsearch ./elasticsearch/
docker push [name]/elasticsearch
# Run on the cluster
fleetctl start ./elasticsearch/systemd/elasticsearch@{0,1}.service
```
The simple regex "{0,1}" defines the instances to start.

# Kibana

Kibana and elastic search are seperated, there was no need for these to be on the
same box. (Seperation of concerns etc).

This container is Kibana + Nginx. Kibana talks to Elasticsearch directly, the nginx server
on this container provides a reverse proxy and a host for kibana.

`http://kibana-host:9100` will serve the pages then the ajax requests are reverse
proxied to the Elasticsearch cluster. (There could be 1-n boxes etc).

This also means as Elasticsearch box is added/removed the reverse proxy is reconfigured
so kibana will never know the difference.

**Building Kibana docker image and starting it in fleet:**
```bash
# Build task
docker build -t [name]/kibana ./kibana/
docker push [name]/kibana
# Run on the cluster
fleetctl start ./kibana/systemd/kibana.service
```



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
