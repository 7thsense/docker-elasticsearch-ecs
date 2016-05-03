#!/bin/bash

set -e

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
        set -- elasticsearch "$@"
fi

export ES_JAVA_OPTS=-Djava.net.preferIPv4Stack=true

# ECS will report the docker interface without help, so we override that with host's private ip
if [ -f /sys/hypervisor/uuid ] && [ `head -c 3 /sys/hypervisor/uuid` == ec2 ]; then
	STARTUP_FLAGS=-Ecloud.node.auto_attributes: true\
        -Ecluster.routing.allocation.awareness.attributes: aws_availability_zone
else
	STARTUP_FLAGS=-Ecloud.node.auto_attributes: true\
        -Ecluster.routing.allocation.awareness.attributes: aws_availability_zone
fi

# Drop root privileges if we are running elasticsearch
if [ "$1" = 'elasticsearch' ]; then
    # Change the ownership of /usr/share/elasticsearch/data to elasticsearch
    chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data

	set -- "$@" -Epath.conf=/etc/elasticsearch $STARTUP_FLAGS \
		-Enetwork.host=_site_\
		-Expack.security.enabled=false
    exec gosu elasticsearch "$@"
else
	# As argument is not related to elasticsearch,
	# then assume that user wants to run his own process,
	# for example a `bash` shell to explore this image
	exec "$@"
fi

