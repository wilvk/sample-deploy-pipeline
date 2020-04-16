# Getting Started

After cloning this repository, you will need to source the file `SOURCEME.sh`.

For example:

```bash
source SOURCEME.sh
```

To start the Jenkins container, from the command line, enter `appsec_start`.

Once complete, you will see the Jenkins admin password to log into the Jenkins server.

```text
...
Successfully built fb2400e27e11
Successfully tagged jenkins-docker:latest
   -> Starting docker container for sample-deploy-pipeline... 
   -> Sleeping for 30 seconds before retrieving credentials... 
   -> Retrieving Jenkins admin credentials from Jenkins... 
     -> admin password: 1d3a35e2c74349fc9e2a1c3600201e60
   -> To access the Jenkins server, browse to 'http://localhost:8080'. 
➜  sample-deploy-pipeline git:(master)
```

## Setting up Jenkins

The Jenkins web server is on [localhost:8080](http://localhost:8080) You will see the following page.

<img src="images/getting-started-unlock-jenkins.png" width="600"/>

The admin password is as described in the [Getting Started](#getting-started) section, or alternatively by running `appsec_get_jenkins_admin_creds`.

Install the recommended plugins

<img src="images/getting-started-customize-jenkins.png" width="600"/>

You will then see the plugins being installed.

<img src="images/getting-started-installing-plugins.png" width="600"/>

Don't fill out any details on this form, just select `Continue as admin`.

<img src="images/getting-started-create-first-admin-user.png" width="600"/>

Select `Save and Finish`.

<img src="images/getting-started-instance-configuration.png" width="600"/>

Select `Start using Jenkins`.

<img src="images/getting-started-jenkins-is-ready.png" width="600"/>

Jenkins should now be setup.

<img src="images/getting-started-welcome-to-jenkins.png" width="600"/>
