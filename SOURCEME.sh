#!/usr/bin/env sh

echo $_ $0 1>/dev/null

if [[ "$_" = "$0" ]];
then
  echo "error: script is being run directly."
  echo "please source this file. e.g. 'source $0'."
  exit 1
fi

export APPSEC_ROOT_PATH=$(pwd)

function appsec_build() {
    docker build -t jenkins-docker .
}

function appsec_start_jenkins() {
    docker run -it -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock --restart unless-stopped jenkins-docker 1>/dev/null
    echo "please wait 30 seconds before retrieving credentials."
}

function appsec_get_jenkins_admin_creds() {
    DOCKER_IMAGE=$(docker ps -qf "ancestor=jenkins-docker")
    ADMIN_USER=$(docker exec -it $DOCKER_IMAGE cat /var/jenkins_home/secrets/initialAdminPassword)
    echo "username: admin"
    echo "password: $ADMIN_USER"
}

function appsec_list() {
    compgen -A function|grep "appsec_"
}

function appsec_get_jenkins_shell() {
    docker exec -it $(docker ps -qf "ancestor=jenkins-docker") bash 
}

function appsec_cleanup() {
    docker kill $(docker ps -qf "ancestor=jenkins-docker") 2> /dev/null
    docker image prune --force
    docker image rm jenkins-docker -f
    docker image rm  jenkins/jenkins
    docker volume rm jenkins_home
}


echo "helper functions have been added to your command line."
echo "for a list of appsec helper functions type 'appsec_list'."


