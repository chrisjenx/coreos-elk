#
# Haproxy Dockerfile
#
# https://github.com/dockerfile/haproxy
#

# Pull base image.
FROM dockerfile/ubuntu

# Env
# These should be set when running the container
ENV PRIVATE_IPV4 0.0.0.0
ENV PUBLIC_IPV4 0.0.0.0

# Install confd
ENV CONFD_VERSION 0.5.0
RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v$CONFD_VERSION/confd-$CONFD_VERSION-linux-amd64 -o /usr/local/bin/confd \
  && chmod 0755 /usr/local/bin/confd

# Make dirs for confd
RUN mkdir -p /etc/confd/conf.d
RUN mkdir -p /etc/confd/templates
# Add files
ADD ./confd           /etc/confd
ADD ./bin/boot.sh     /boot.sh

# Install Haproxy.
RUN \
  sed -i 's/^# \(.*-backports\s\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y haproxy=1.5.3-1~ubuntu14.04.1 && \
  sed -i 's/^ENABLED=.*/ENABLED=1/' /etc/default/haproxy && \
  rm -rf /var/lib/apt/lists/*

# Expose ports.
EXPOSE 80
EXPOSE 8080
EXPOSE 443
#Logstash
# - http
# - transport
EXPOSE 9200
EXPOSE 9300

# Start Elasticsearch
RUN chmod +x /boot.sh
CMD ["bash", "/boot.sh"]
