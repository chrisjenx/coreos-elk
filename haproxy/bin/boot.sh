#!/usr/bin/env bash

# Fail hard and fast
set -eo pipefail

export PUBLIC_IPV4=${PUBLIC_IPV4}
export PRIVATE_IPV4=${PRIVATE_IPV4}

readonly ETCD_PORT=${ETCD_PORT:-4001}
readonly ETCD=$PUBLIC_IPV4:$ETCD_PORT

readonly HAPROXY_PID="/var/run/haproxy.pid"
readonly HAPROXY_CFG="/etc/haproxy/haproxy.cfg"

echo "[haproxy] booting container. ETCD: $ETCD"

start_haproxy() {
  haproxy -f $HAPROXY_CFG -db &
  local pid=$!
  echo "$pid" > $HAPROXY_PID
}

start() {
  start_haproxy
  confd -verbose -interval 10 -node $ETCD -config-file /etc/confd/conf.d/haproxy.toml
  echo "[haproxy] confd is listening for changes on etcd..."
}

start
