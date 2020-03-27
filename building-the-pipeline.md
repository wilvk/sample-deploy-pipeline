# Building the pipeline

Select 'New item', enter the name 'AppSec 101' for the project, select 'Feestyle project' and click 'OK'

- Select source code management: git and enter the HTTPS URL of your fork of the `sample-flask-app` repository
- Under the heading 'Build' select 'Add build step' > 'Execute shell'
  In the 'Command' box enter: `docker-compose down; docker-compose up -d; sleep 10; docker-compose logs`
- Save
- Build Now
- On the command line on your host machine, enter `docker ps` and you will see the app running.
- In the browser, browse to 'localhost:8000' to see your app.

This will execute the flask app on the jenkins server.
