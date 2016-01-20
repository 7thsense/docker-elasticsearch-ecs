.PHONY: default
default:
	docker build .

publish: default
	docker build -t 7thsense/elasticsearch-ecs:latest .
	docker push 7thsense/elasticsearch-ecs:latest
