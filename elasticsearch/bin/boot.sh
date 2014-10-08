#!/bin/bash

# Fail hard and fast
set -eo pipefail

export PUBLIC_IPV4=${PUBLIC_IPV4}
export PRIVATE_IPV4=${PRIVATE_IPV4}

export ETCD_PORT=${ETCD_PORT:-4001}
export ETCD=$PUBLIC_IPV4:$ETCD_PORT

echo "[elasticsearch] booting container. ETCD: $ETCD"

# Try and find other nodes in the cluster
# Loop until confd has updated the logstash config
echo "[elasticsearch] waiting for confd to refresh elasticsearch.yaml"
confd -verbose -onetime -node $ETCD -confdir /etc/confd
echo "[elasticsearch] elasticsearch.yml start"
cat /opt/elasticsearch/config/elasticsearch.yml
echo "[elasticsearch] elasticsearch.yml end"


# Start logstash
echo "[elasticsearch] starting elasticsearch agent..."
/opt/elasticsearch/bin/elasticsearch
