# sample-deploy-pipeline

Jenkins, docker and docker-compose in a container for building and deploying projects.

## instructions

### getting started

You will need to source the file `SOURCEME.sh`. For example:

```bash
source SOURCEME.sh
```

To start the Jenkins container, enter `appsec_start`.

Once complete you will see the Jenkins admin password to log into the Jenkins server.

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

