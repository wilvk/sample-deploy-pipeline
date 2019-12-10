# sample-deploy-pipeline

Jenkins, docker and docker-compose in a container for building and deploying projects.

## instructions

### build

```bash
docker build -t jenkins-docker .
```

### run as deamon with web server on port 8080

```bash
docker run -it -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock --restart unless-stopped jenkins-docker
```

### to get admin password

```bash
docker exec -it $(docker ps -qf "ancestor=jenkins-docker") cat /var/jenkins_home/secrets/initialAdminPassword
```

### logging in

Jenkins web server is on `localhost:8080` user: admin password: _from above_

### to get a terminal
```
docker exec -it $(docker ps -qf "ancestor=jenkins-docker") bash 
```

### remove jenkins-docker image 

```
docker kill $(docker ps -qf "ancestor=jenkins-docker") 2> /dev/null ; docker image rm jenkins-docker --force; docker image prune --force; docker system prune --force
```

