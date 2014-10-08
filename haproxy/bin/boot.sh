#!/bin/bash

# Fail hard and fast
set -eo pipefail

export PUBLIC_IPV4=${PUBLIC_IPV4}
export PRIVATE_IPV4=${PRIVATE_IPV4}

export ETCD_PORT=${ETCD_PORT:-4001}
export ETCD=$PUBLIC_IPV4:$ETCD_PORT

echo "[haproxy] booting container. ETCD: $ETCD"

# Loop until confd has updated the nginx config
until confd -verbose -onetime -node $ETCD -confdir /etc/confd; do
  echo "[haproxy] waiting for confd to refresh haproxy.conf"
  sleep 5
done

# Run confd in the background to watch the upstream servers
confd -verbose -interval 10 -node $ETCD -confdir /etc/confd &
echo "[haproxy] confd is listening for changes on etcd..."

# Start nginx
echo "[haproxy] starting haproxy service..."
/usr/sbin/service haproxy start
