#!/usr/bin/env sh

export APPSEC_ROOT_PATH=$(pwd)
export APPSEC_IMAGE_VERSION="will01/appsec-101:0.1.0"

function appsec_echo() {
    echo "$APPSEC_TEXT_START $1 $APPSEC_TEXT_END"
}

function appsec_pull() {
    docker pull ${APPSEC_IMAGE_VERSION}
}

function appsec_start_jenkins() {
    docker run -it -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock --restart unless-stopped ${APPSEC_IMAGE_VERSION} 1>/dev/null
}

function appsec_get_jenkins_admin_creds() {
    DOCKER_IMAGE=$(docker ps -qf "ancestor=${APPSEC_IMAGE_VERSION}")
    if [ -z "$DOCKER_IMAGE" ];
    then
      appsec_echo "    -> error: no docker container found with name ${APPSEC_IMAGE_VERSION}"
    else
      ADMIN_USER=$(docker exec -it $DOCKER_IMAGE cat /var/jenkins_home/secrets/initialAdminPassword)
      appsec_echo "    -> admin password: ${ADMIN_USER}"
    fi
}

function appsec_list() {
  FUNCTION_LIST=$(grep -E '^function\sappsec' ${APPSEC_ROOT_PATH}/SOURCEME.sh|sed -e 's/function \(appsec.*\)() {/\1/')
  appsec_echo $FUNCTION_LIST
}

function appsec_get_jenkins_shell() {
    docker exec -it $(docker ps -qf "ancestor=${APPSEC_IMAGE_VERSION}") bash
}

function appsec_stop() {
    DOCKER_IMAGE=$(docker ps -qf "ancestor=${APPSEC_IMAGE_VERSION}") 1>/dev/null
    if [ -z "$DOCKER_IMAGE" ];
    then
      appsec_echo "  -> no docker container found with name ${APPSEC_IMAGE_VERSION}"
    else
      docker stop $DOCKER_IMAGE
      appsec_echo "  -> docker container with name ${APPSEC_IMAGE_VERSION} and id $DOCKER_IMAGE has been stopped."
    fi
}

function appsec_cleanup() {
    appsec_echo "  -> stopping ${APPSEC_IMAGE_VERSION} container..."
    appsec_stop
    appsec_echo "  -> removing ${APPSEC_IMAGE_VERSION} image..."
    docker image rm ${APPSEC_IMAGE_VERSION} --force
    appsec_echo "  -> pruning dangling images..."
    docker image prune --force
    appsec_echo "  -> pruning dangling containers..."
    docker container prune --force
    appsec_echo "  -> removing jenkins-home volume..."
    docker volume rm jenkins_home
}

function appsec_start() {
    appsec_echo "Starting appsec sample-deploy-pipeline with docker image ${APPSEC_IMAGE_VERSION}..."
    appsec_echo "  -> Cleaning up any previous run of sample-deploy-pipeline..."
    appsec_cleanup
    appsec_echo "  -> Pulling docker image for ${APPSEC_IMAGE_VERSION}..."
    appsec_pull
    appsec_echo "  -> Starting docker container for ${APPSEC_IMAGE_VERSION}..."
    appsec_start_jenkins
    appsec_echo "  -> Sleeping for 30 seconds before retrieving credentials..."
    sleep 30s
    appsec_echo "  -> Retrieving Jenkins admin credentials from Jenkins..."
    appsec_get_jenkins_admin_creds
    appsec_echo "  -> To access the Jenkins server, browse to 'http://localhost:8080'."
}

appsec_echo "AppSec helper functions have been added to your command line."
appsec_echo "  -> for a list of appsec helper functions type 'appsec_list'."
appsec_echo "  -> to start the application type 'appsec_start'."
appsec_echo "  -> to stop the application type 'appsec_stop'."
appsec_echo "  -> to cleanup the application type 'appsec_cleanup'."
