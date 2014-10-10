# Pull base image.
FROM dockerfile/ubuntu
MAINTAINER Christopher Jenkins <chris.mark.jenkins@gmail.com>

ENV PRIVATE_IPV4 0.0.0.0
ENV PUBLIC_IPV4 0.0.0.0


# Install Nginx.
RUN \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y nginx && \
  rm -rf /var/lib/apt/lists/* && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx

# Install confd
ENV CONFD_VERSION 0.6.3
RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v$CONFD_VERSION/confd-$CONFD_VERSION-linux-amd64 -o /usr/local/bin/confd \
  && chmod 0755 /usr/local/bin/confd

# Add confd files
ADD ./confd /etc/confd/

# Remove default site
RUN rm -f /etc/nginx/sites-enabled/default

# Add boot script
ADD ./bin/boot.sh /boot.sh
RUN chmod +x /boot.sh

# Expose ports.
#   - Elasticsearch http
#
#
EXPOSE 9200

# Run the boot script
CMD /boot.sh
