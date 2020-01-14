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

(wait a minute for the daemon / web server to finish starting up)

```bash
docker exec -it $(docker ps -qf "ancestor=jenkins-docker") cat /var/jenkins_home/secrets/initialAdminPassword
```

### logging in

Jenkins web server is on `localhost:8080` user: admin password: _from above_

### setting up the pipeline

- Install the recommended plugins
- Select 'Continue as admin' then 'Save and Finish' and 'Restart' then refresh the browser and re-enter the admin credentials.
- Select 'New item', enter a name for the project, select 'Feestyle project' and click 'OK'
- Select source code management: git and enter the HTTPS URL of your fork of the `sample-flask-app` repository
- Under the heading 'Build' select 'Add build step' > 'Execute shell'
  In the 'Command' box enter: `docker-compose down; docker-compose up -d; sleep 10; docker-compose logs`
- Save
- Build Now
- On the command line on your host machine, enter `docker ps` and you will see the app running.
- In the browser, browse to 'localhost:8000' to see your app.

This will execute the flask app on the jenkins server.

### to get a terminal on the jenkins container

```bash
docker exec -it $(docker ps -qf "ancestor=jenkins-docker") bash 
```

You can find the working directory at `/var/jenkins_home/workspace/`.

### remove jenkins-docker image (to clean up when we're done)

```bash
docker kill $(docker ps -qf "ancestor=jenkins-docker") 2> /dev/null ; docker image rm jenkins-docker --force; docker image prune --force
```

