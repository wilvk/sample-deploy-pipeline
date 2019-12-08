FROM jenkins/jenkins:lts
MAINTAINER 4oh4

# Derived from https://github.com/4OH4/jenkins-docker/blob/master/Dockerfile

USER root

# Install the latest Docker CE binaries and add user `jenkins` to the docker group
RUN apt-get update && \
    apt-get -y install apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) \
      stable" && \
   apt-get update && \
   apt-get -y install docker-ce && \
   usermod -aG docker jenkins

# install docker-machine
RUN curl -L https://github.com/docker/machine/releases/download/v0.16.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && \
    chmod +x /tmp/docker-machine && \
    cp /tmp/docker-machine /usr/local/bin/docker-machine

# install docker-compose
RUN apt-get update && apt-get -y install docker-compose 

# copy and install plugins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt

# allow jenkins user to access docker
RUN usermod -aG docker jenkins

# drop back to the regular jenkins user - good practice
USER jenkins
