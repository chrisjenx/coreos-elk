#
# Logstash Dockerfile
#
# https://github.com/chrisjenx/coreos-elk/logstash
#

# Pull base image.
FROM dockerfile/java:oracle-java7

MAINTAINER Chris Jenkins <chris.mark.jenkins@gmail.com>

# Vars
ENV CONFD_VERSION 0.5.0
ENV LOGSTASH_VERSION 1.4.2
ENV PRIVATE_IPV4 0.0.0.0
ENV PUBLIC_IPV4 0.0.0.0

# Install confd
RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v$CONFD_VERSION/confd-$CONFD_VERSION-linux-amd64 -o /usr/local/bin/confd
RUN chmod 0755 /usr/local/bin/confd

# Create directories
RUN mkdir -p /opt/logstash/ssl
RUN mkdir -p /etc/confd/conf.d
RUN mkdir -p /etc/confd/templates

# Install Logstash
RUN curl https://download.elasticsearch.org/logstash/logstash/logstash-$LOGSTASH_VERSION.tar.gz \
  -o /tmp/logstash-$LOGSTASH_VERSION.tar.gz
RUN tar -xzvf /tmp/logstash-$LOGSTASH_VERSION.tar.gz -C /opt/logstash --strip-components=1
RUN rm /tmp/logstash-$LOGSTASH_VERSION.tar.gz

# Install contrib plugins
RUN /opt/logstash/bin/plugin install contrib

# Add files
ADD ./confd                   /etc/confd
ADD ./bin/boot.sh             /boot.sh

# Kibana
EXPOSE 9292

# Start the container
RUN chmod +x /boot.sh
CMD /boot.sh
