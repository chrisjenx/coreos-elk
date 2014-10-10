#!/bin/bash

# Fail hard and fast
set -eo pipefail

export PUBLIC_IPV4=${PUBLIC_IPV4}
export PRIVATE_IPV4=${PRIVATE_IPV4}

export ETCD_PORT=${ETCD_PORT:-4001}
export HOST_IP=${PRIVATE_IPV4:-172.17.42.1}
export ETCD=$HOST_IP:$ETCD_PORT

echo "[kibana] booting container. ETCD: $ETCD"

# Loop until confd has updated the nginx config
until confd -verbose -onetime -node $ETCD -config-file /etc/confd/conf.d/nginx.toml; do
  echo "[kibana] waiting for confd to refresh nginx.conf"
  sleep 5
done

# Run confd in the background to watch the upstream servers
confd -interval 10 -node $ETCD -config-file /etc/confd/conf.d/nginx.toml &
echo "[kibana] confd is listening for changes on etcd..."

# Start nginx
echo "[kibana] starting nginx service..."
service nginx start

# Tail all nginx log files
tail -f /var/log/nginx/*.log
