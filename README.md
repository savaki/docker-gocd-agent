# docker-gocd-agent
gocd agent with go, fpm, and sass pre-installed

## Host Prerequisites

* docker installed 
* docker login invoked 
* SSH_KEY env set to canonical path to ssh key
* GO_SERVER env variable set to ip address of GO_SERVER

## Usage:

```
docker run -d \
	--volume ${SSH_KEY}:/root/.ssh/id_rsa:ro \
	--volume ${HOME}/.dockercfg:/root/.dockercfg:ro \
	--volume /var/run/docker.sock:/var/run/docker.sock \
	--env GO_SERVER=${GO_SERVER} \
	agent:latest 
```

## Usage with MySQL
	
```
export MYSQL_ID=$(docker run -e MYSQL_ROOT_PASSWORD=password -d mysql:5.6)

docker run -d \
	--link ${MYSQL_ID}:mysql \
	--volume ${SSH_KEY}:/root/.ssh/id_rsa,ro \
	--volume ${HOME}/.dockercfg:/root/.dockercfg,ro \
	--volume /var/run/docker.sock:/var/run/docker.sock \
	--env GO_SERVER=${GO_SERVER} \
	agent:latest 

```
