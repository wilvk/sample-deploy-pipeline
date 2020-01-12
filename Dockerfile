FROM jenkins/jenkins:lts

USER root

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common \
     vim \
     wget \
     python3-dev \
     gcc \
     ansible \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*


ARG GOSU_VERSION=1.10

RUN dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
 && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
 && chmod +x /usr/local/bin/gosu \
 && gosu nobody true

ARG DOCKER_CLI_VERSION==5:19.03.0~3-0~debian-stretch

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
 && add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/debian \
     $(lsb_release -cs) \
     stable" \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    docker-ce-cli${DOCKER_CLI_VERSION} \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && groupadd -r docker \
 && usermod -aG docker jenkins

RUN apt-get update && apt-get -y install docker-compose

COPY plugins.txt /usr/share/jenkins/plugins.txt

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

HEALTHCHECK CMD curl -sSLf http://localhost:8080/login >/dev/null || exit 1
