#
# ElasticSearch Dockerfile
#
# https://github.com/chrisjenx/coreos-elk/elasticsearch
#

# Pull base image.
FROM dockerfile/java:oracle-java7

MAINTAINER Christopher Jenkins <chris.mark.jenkins@gmail.com>

# Install ElasticSearch.
RUN \
  cd /tmp && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.4.tar.gz && \
  tar xvzf elasticsearch-1.3.4.tar.gz && \
  rm -f elasticsearch-1.3.4.tar.gz && \
  mv /tmp/elasticsearch-1.3.4 /opt/elasticsearch

# Install plugins
RUN /opt/elasticsearch/bin/plugin -install lmenezes/elasticsearch-kopf
RUN /opt/elasticsearch/bin/plugin -url http://download.elasticsearch.org/kibana/kibana/kibana-latest.zip -install elasticsearch/kibana3

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300

# Start Elasticsearch
CMD /opt/elasticsearch/bin/elasticsearch
