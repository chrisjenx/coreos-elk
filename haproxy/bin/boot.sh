#!/bin/bash

# Fail hard and fast
set -eo pipefail

export PUBLIC_IPV4=${PUBLIC_IPV4}
export PRIVATE_IPV4=${PRIVATE_IPV4}

export ETCD_PORT=${ETCD_PORT:-4001}
export ETCD=$PUBLIC_IPV4:$ETCD_PORT

export HAPROXY="/etc/haproxy"

echo "[haproxy] booting container. ETCD: $ETCD"

# Loop until confd has updated the nginx config
until confd -verbose -onetime -node $ETCD -config-file /etc/confd/conf.d/haproxy.toml; do
  echo "[nginx] waiting for confd to refresh haproxy.cfg"
  sleep 5
done

# Run confd in the background to watch the upstream servers
confd -verbose -interval 10 -node $ETCD -config-file /etc/confd/conf.d/haproxy.toml &
echo "[haproxy] confd is listening for changes on etcd..."

cd "$HAPROXY"

echo "[haproxy] starting haproxy agent..."
haproxy -f /etc/haproxy/haproxy.cfg -p "/var/run/haproxy.pid" -sf $(cat /var/run/haproxy.pid)
