#!/usr/bin/env bash

rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch 

rpm -ivh https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/2.3.2/elasticsearch-2.3.2.rpm

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
bin/plugin install cloud-aws
bin/plugin install lmenezes/elasticsearch-kopf
bin/plugin install mobz/elasticsearch-head
bin/plugin install royrusso/elasticsearch-HQ
# for ES 2.0
bin/plugin install license
bin/plugin install marvel-agent


