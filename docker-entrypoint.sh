#!/bin/bash

set -e

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
        set -- elasticsearch "$@"
fi

export ES_USE_IPV4=true

# ECS will report the docker interface without help, so we override that with host's private ip
if [ -f /sys/hypervisor/uuid ] && [ `head -c 3 /sys/hypervisor/uuid` == ec2 ]; then
	AVAILABILITY_ZONE=`curl http://169.254.169.254/latest/meta-data/placement/availability-zone`
	#PUBLISH_HOST=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
	PUBLISH_HOST=_ec2:privateDns_
fi

# Drop root privileges if we are running elasticsearch
if [ "$1" = 'elasticsearch' ]; then
    # Change the ownership of /usr/share/elasticsearch/data to elasticsearch
    chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data

	if [[ "$AVAILABILITY_ZONE" == "" ]]; then
		AVAILABILITY_ZONE=default
	fi
	if [[ "$PUBLISH_HOST" == "" ]]; then
		PUBLISH_HOST=_non_loopback:ipv4_
	fi
	set -- "$@" --network.publish_host=$PUBLISH_HOST --node.availability-zone=$AVAILABILITY_ZONE

    exec gosu elasticsearch "$@"
else
	# As argument is not related to elasticsearch,
	# then assume that user wants to run his own process,
	# for example a `bash` shell to explore this image
	exec "$@"
fi

