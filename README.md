
Jenkins, docker and docker-compose in a container for building and deploying projects

# instructions

## build

```bash
docker build -t jenkins-docker .
```

## run as deamon with web server on port 8080

```bash
docker run -it -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock --restart unless-stopped jenkins-docker
```


# to get admin password

```bash
$ docker exec -it $(docker ps -qf "ancestor=jenkins-docker") cat /var/jenkins_home/secrets/initialAdminPassword
```
