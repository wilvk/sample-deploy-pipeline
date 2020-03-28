# Secrets Management with Ansible-Vault

## Go to the deploy workspace

On the host machine, shell into the container with the command:

```
docker exec -it $(docker ps -qf "ancestor=jenkins-docker") bash 
```

## Create an Ansible Vault file

```
ansible-vault create env_secrets
```

Enter a password for the vault file. Make a note of your password.

In the Vim editor, enter `-- INSERT --` mode by pressing 'i'.

Enter the user name and password as following:

```
DB_USER=postgres
DB_PASS=postgres
```

Press `Esc` to exit insert mode. Enter ':wq' to write the changes and exit the editor.

## Viewing the vault file

To view the contents of the vault file, enter the command:

```
ansible-vault view env_secrets
```

To view the encrypted vault file enter:

```
cat env_secrets
```

## Add the vault file to the sample-flask-app

Copy the encrypted vault file contents from the previous `cat env_secrets` command to the clipboard.

Create a file in the sample-flask-app repository called `env_secrets` and paste the vault contents into this file.

Save the file, commit the changes and push the commit to your fork of the repository. This is error-prone, so check what is pasted is what is in the original file before saving.

## Updating the app config

In the sample-flask-app repository open the file `web/config.py` in your editor.

Change line 7 and 8 from:

```python3
    DB_NAME = "postgres"
    DB_USER = "postgres"

```

to:

```python3
    DB_USER = os.environ["DB_USER"]
    DB_PASS = os.environ["DB_PASS"]

```

Save the changes.

Open the file `.env' and add the following lines to the bottom of the file:

```
DB_USER
DB_PASS
```

This will allow the environment variables to be passed through from the jenkins host to the application.

Do another commit and push with your changes.

## Set the environment variables in the jenkins host for the deploy pipeline

Browse to `localhost:8080` and login to the Jenkins server if necessary.

### Add the Ansible Vault password to Jenkins Credential Store

From the Jenkins Dashboard, select 'Credentials'
Click on the '(global)' link next to the 'Jenkins' link.
Select 'Add Credentials'
Change 'Kind' to 'Secret Text'
Enter your password in the 'Secret' textbox
Enter `ANSIBLE_VAULT_PASSWORD` in the 'Id' textbox
Click 'OK'

### Add the Ansible Vault Password to the pipeline and export the database credentials to the environment

Go into the config for your project

Under 'Bindings', select the 'Add' dropdown box and select 'Secret text'
In the 'Variable' textbox enter `ANSIBLE_VAULT_PASSWORD`

```
set +x
export $(echo "${ANSIBLE_VAULT_PASSWORD}" > .vault_pass.txt && ansible-vault view --vault-password-file=.vault_pass.txt env_secrets|xargs)
docker-compose down; docker-compose up -d; sleep 10; docker-compose logs
rm .vault_pass.txt
```

- `set -x` prevents commands being output to the Jenkins logs. This is important as the credentials are passed to the environment variables as bash commands.
- `rm .vault_pass.txt` cleans up the password file.

Save the changes and select 'Build Now'.

The logs may show that the password is not set. This is because we are using the default Postgres credentials. In a production environment the username/password should not be the default credentials.

Check your application at `localhost:8000` it should be running.

# Conclusion:

This section has shown two ways of storing secrets:

- Using Ansible Vault to encrypt our database credentials with a password.
- Using Jenkins Credential Store to store our Ansible Vault password and then use this password to deecrypt our database credentials
