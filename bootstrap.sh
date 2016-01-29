#!/usr/bin/env bash

rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

rpm -ivh https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.4.noarch.rpm

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
bin/plugin -i elasticsearch/elasticsearch-cloud-aws/2.7.1
bin/plugin -i lmenezes/elasticsearch-kopf/1.0
bin/plugin -i mobz/elasticsearch-head
bin/plugin -i royrusso/elasticsearch-HQ/v1.0.0
bin/plugin install license
bin/plugin install marvel-agent


