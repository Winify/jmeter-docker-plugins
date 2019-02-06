# JMeter-Docker image

Added funcionality for Dockerfile:
* Option for installing JMeter Plugins

Building:
* docker build -t jmeter-docker[:tag] .

Run in docker container:
* docker run --rm --name jmeter -v $PWD/tests:/opt/tests -v $PWD/results:/opt/results jmeter-docker google