#!/usr/bin/env bash
yum install -y hostname
rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch 

rpm -ivh https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.5.0.rpm

set -ex \
	&& for path in \
		/usr/share/elasticsearch/data \
		/usr/share/elasticsearch/logs \
		/usr/share/elasticsearch/config \
		/usr/share/elasticsearch/config/scripts \
	; do \
		mkdir -p "$path"; \
		chown -R elasticsearch:elasticsearch "$path"; \
	done

cd /usr/share/elasticsearch
bin/elasticsearch-plugin install discovery-ec2
bin/elasticsearch-plugin install repository-s3
#bin/elasticsearch-plugin install lmenezes/elasticsearch-kopf
#bin/elasticsearch-plugin install mobz/elasticsearch-head
#bin/elasticsearch-plugin install royrusso/elasticsearch-HQ
# for ES 2.0
#bin/elasticsearch-plugin install license
#bin/elasticsearch-plugin install marvel-agent


