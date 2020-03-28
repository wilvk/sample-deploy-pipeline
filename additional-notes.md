# Additional Notes

## To get a terminal on the jenkins container

```bash
appsec_get_jenkins_shell
```

## Jenkins working directory

You can find the working directory at `/var/jenkins_home/workspace/`.

## To remove the `jenkins-docker` image, container and volume:

```bash
appsec_cleanup
```

## To stop the `jenkins-docker` container temporarily:

```bash
appsec_start
```

## To restart a stopped `jenkins-docker` container:

```bash
appsec_start_jenkins
```

`
