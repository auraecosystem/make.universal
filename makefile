node:
	docker build -f images/node.Dockerfile -t makeuniversal-node .

python:
	docker build -f images/python.Dockerfile -t makeuniversal-python .

clean:
	docker system prune -af
