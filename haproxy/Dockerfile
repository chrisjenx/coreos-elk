#
# Haproxy Dockerfile
#
# https://github.com/dockerfile/haproxy
#
FROM ubuntu:trusty
MAINTAINER Chris Jenkins <chris.mark.jenkins@gmail.com>


# Env - These should be set when running the container
ENV DEBIAN_FRONTEND noninteractive
ENV PRIVATE_IPV4 0.0.0.0
ENV PUBLIC_IPV4 0.0.0.0
ENV CONFD_VERSION 0.5.0

# Install Haproxy.
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 505d97a41c61b9cd
RUN echo "deb http://ppa.launchpad.net/vbernat/haproxy-1.5/ubuntu trusty main" > /etc/apt/sources.list.d/haproxy.list
RUN apt-get update -q
RUN apt-get install -y -q haproxy curl

# Install confd
RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v$CONFD_VERSION/confd-$CONFD_VERSION-linux-amd64 -o /usr/local/bin/confd \
  && chmod 0755 /usr/local/bin/confd

# Add files
ADD ./confd           /etc/confd
ADD ./bin/boot.sh     /usr/local/bin/start_haproxy

# Allow confd to be exec
RUN chmod +x /usr/local/bin/confd
RUN chmod +x /usr/local/bin/start_haproxy

# Expose ports.
EXPOSE 80
EXPOSE 8080
EXPOSE 443
#Logstash
# - http
# - transport
EXPOSE 9199
# EXPOSE 9200
# EXPOSE 9300

CMD start_haproxy
