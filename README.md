This is a basic docker image for running elasticsearch on Amazon ECS. 

It supports auto-scaling and can use ec2-cluster discovery to configure itself. The task.json file
in this folder should work out of the box as a task definition, you just need to put in the 
security group id for your instances in the file where it says "sg-XXXXXXXX"
and (optionally) make sure they have a suitably sized volume
mounted at /var/data/vol00.

You should also configure your ecs container to use "host" networking and expose ports 9200 and 9300.

It is accessible via Docker Hub via `7thsense/elasticsearch-ecs:latest`

Much of this was taken from from 
http://blog.dmcquay.com/devops/2015/09/12/running-elasticsearch-on-aws-ecs.html,
many thanks to Dustin McQuay for putting that together. The rest comes from the 
official elasticsearch images at https://github.com/docker-library/elasticsearch -
this image has primarily been modified to run under a rhel-variant with the officially
support oracle JDK.
