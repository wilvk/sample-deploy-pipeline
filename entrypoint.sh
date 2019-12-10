#!/bin/sh

set -x

set -- tini -- /usr/local/bin/jenkins.sh "$@"

if [ "$(id -u)" = "0" ]; then
  SOCK_DOCKER_GID=$(ls -ng /var/run/docker.sock | cut -f3 -d' ')
  CUR_DOCKER_GID=$(getent group docker | cut -f3 -d: || true)
  if [ ! -z "$SOCK_DOCKER_GID" -a "$SOCK_DOCKER_GID" != "$CUR_DOCKER_GID" ]; then
    groupmod -g ${SOCK_DOCKER_GID} -o docker
  fi
  if ! groups jenkins | grep -q docker; then
    usermod -aG docker jenkins
  fi
  set -- gosu jenkins "$@"
fi

exec "$@"
