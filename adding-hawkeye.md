# Adding Hawkeye to the deploy pipeline

Add the following to the sample-flask-app's `docker-compose.yml` file:

```yaml
#services:
  #...
  hawkeye:
    image: stono/hawkeye
    command: scan --target /usr/src/app
    volumes_from:
      - web
```

Add a new “Execute shell” build step to run Hawkeye with the following command:

```sh
docker-compose run hawkeye
```

<img src="images/adding-hawkeye-add-build-step.png" width="500"/>

## Running Hawkeye
Return to the `sample-flask-app` job and select `Build Now`. This time you should see the build fail, navigate into the build instance and review the console output to discover why. What changes would we need to make to get the build passing again?