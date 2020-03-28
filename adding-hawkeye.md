# Adding Hawkeye to the deploy pipeline

Add the following to the sample-flask-app docker-compose.yml:

```docker
hawkeye:
    image: stono/hawkeye
    command: scan --target /usr/src/app
    volumes_from:
      - web
```

Add a build step to run Hawkeye with the following command:

```
docker-compose run hawkeye
```
