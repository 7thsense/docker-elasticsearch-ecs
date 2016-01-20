FROM 7thsense/java:8
MAINTAINER Erik LaBianca <erik@7thsense.io>

ADD docker-entrypoint.sh /
ADD bootstrap.sh /root/bootstrap.sh
RUN /root/bootstrap.sh && rm /root/bootstrap.sh && chmod a+x /docker-entrypoint.sh

ENV ELASTICSEARCH_MAJOR 1.7
ENV ELASTICSEARCH_VERSION 1.7.4

ENV PATH /usr/share/elasticsearch/bin:$PATH
COPY config /usr/share/elasticsearch/config
VOLUME /usr/share/elasticsearch/data

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9200 9300

CMD ["elasticsearch"]
WORKDIR /usr/share/elasticsearch

