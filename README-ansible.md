# sample-deploy-pipeline

Ansible, docker and docker-compose in a container for building and deploying projects.

## instructions

### build

```bash
docker build --file Dockerfile-ansible -t ansible-docker .
```

### to start and get a terminal

```
docker run -it -v /var/run/docker.sock:/var/run/docker.sock --restart unless-stopped ansible-docker bash
```

### remove ansible-docker image 

```
docker kill $(docker ps -qf "ancestor=ansible-docker") 2> /dev/null ; docker image rm ansible-docker --force; docker image prune --force; docker system prune --force
```
