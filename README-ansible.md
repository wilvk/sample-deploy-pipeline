# sample-deploy-pipeline

Ansible, docker and docker-compose in a container for building and deploying projects.

## instructions

### build

```bash
docker build --file Dockerfile-ansible -t ansible-docker .
```

### to start and get a terminal

```bash
docker run -it -v /var/run/docker.sock:/var/run/docker.sock --restart unless-stopped ansible-docker bash
```

### to start the deploy from the container

```bash
ansible-playbook ./ansible-test-pipeline.yaml
```

you can then see the application running on *localhost:8000*


### remove ansible-docker image 

```bash
docker kill $(docker ps -qf "ancestor=ansible-docker") 2> /dev/null ; docker image rm ansible-docker --force; docker image prune --force; docker system prune --force
```
