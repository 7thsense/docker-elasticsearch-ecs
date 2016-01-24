#!/bin/bash

set -e

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
        set -- elasticsearch "$@"
fi

# Drop root privileges if we are running elasticsearch
if [ "$1" = 'elasticsearch' ]; then
        # Change the ownership of /usr/share/elasticsearch/data to elasticsearch
        chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
        exec gosu elasticsearch "$@"
fi

# ECS will report the docker interface without help, so we override that with host's private ip
AWS_AVAILABILITY_ZONE=`curl http://169.254.169.254/latest/meta-data/placement/availability-zone`k
AWS_PRIVATE_IP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
set -- "$@" --network.publish_host=$AWS_PRIVATE_IP --node.availability-zone=$AWS_AVAILABILITY_ZONE

# As argument is not related to elasticsearch,
# then assume that user wants to run his own process,
# for example a `bash` shell to explore this image
exec "$@"
