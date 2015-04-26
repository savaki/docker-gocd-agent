FROM ubuntu:14.04
MAINTAINER Matt Ho

ENV GO_SERVER 127.0.0.1
ENV GO_SERVER_PORT 8153

#--[ DO NOT MODIFY BELOW THIS POINT ]------------------------------------

ENV GOCD_VERSION 14.4.0
ENV GOCD_BUILD 1356

# install oracle jdk 7
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update && apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository ppa:webupd8team/java -y

RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java7-installer

ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

# install dependencies
RUN apt-get update && apt-get install -y curl wget unzip ruby1.9.3

# install go-agent
ENV AGENT_WORK_DIR /var/lib/go-agent/pipelines
ENV DAEMON N
VOLUME ${AGENT_WORK_DIR}
RUN curl -L -o /tmp/gocd-agent.zip http://download.go.cd/gocd/go-agent-${GOCD_VERSION}-${GOCD_BUILD}.zip ; \
	(cd /opt ; unzip -U /tmp/gocd-agent.zip) ; \
	rm /tmp/gocd-agent.zip ; \
	useradd --user-group --create-home go ; \
	chown -R go:go /opt/go-agent-${GOCD_VERSION} ; \
	chmod 755 /opt/go-agent-${GOCD_VERSION}/*.sh ; \
	ln -s /opt/go-agent-${GOCD_VERSION} /opt/go-agent

#--[ BUILD DEPENDENCIES ]------------------------------------------------

RUN apt-get update ; \
	apt-get install -y unzip curl wget ruby1.9.3 build-essential ; \
	gem install sass ; \
	gem install fpm

# install golang
RUN curl -L -o /tmp/golang.tgz https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz ; \
	(cd /usr/local ; tar -xzvf /tmp/golang.tgz) ; \
	rm /tmp/golang.tgz

CMD [ "/opt/go-agent/agent.sh" ]
