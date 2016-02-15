IMAGE:="7thsense/elasticsearch-ecs:latest"
ELASTICSEARCH_PARAMS:=-p 0.0.0.0:9200:9200 -p 0.0.0.0:9300:9300 --volumes-from elasticsearch-data --env PUBLISH_HOST=192.168.102.105

build: Dockerfile bootstrap.sh docker-entrypoint.sh config/*
	docker build .

tag-latest: build
	docker build -t $(IMAGE) .

publish: tag-latest
	docker push $(IMAGE)

start: tag-latest
	docker run $(ELASTICSEARCH_PARAMS) --detach $(IMAGE)

run: tag-latest
	docker run $(ELASTICSEARCH_PARAMS) -ti $(IMAGE)
