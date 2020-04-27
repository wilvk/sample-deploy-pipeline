# Adding Hawkeye to the deploy pipeline

Add the following to the sample-flask-app's `docker-compose.yml` file:

```yaml
hawkeye:
    image: stono/hawkeye
    command: scan --target /usr/src/app
    volumes:
      - ./web:/usr/src/app
```

Add a new “Execute shell” build step to run Hawkeye with the following command:

```sh
docker-compose run hawkeye
```

<img src="images/adding-hawkeye-add-build-step.png" width="500"/>

Now commit the changes to `docker-compose.yml` 

```bash
git add docker-compose.yml
git commit -m 'add hawkeye'
```

## Running Hawkeye
Return to the `sample-flask-app` job and select `Build Now`. This time you should see the build fail, navigate into the build instance and review the console output to discover why. What changes would we need to make to get the build passing again?
