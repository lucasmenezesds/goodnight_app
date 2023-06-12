# Goodnight App

## Before starting

**IMPORTANT**

Please be sure to create an `.env` file before anything else, use `.env.template` as a template for your environment
variables.

In short in the `.env` file you'll set the path for:

- The folder path related to the cache used on bundler.
- The path for the database volume.
- The database settings data such as user, password, host, port, etc.
- The `RAILS_ENV` (If not set, the _default_ value is `development`)

## Running the project using docker

Considering you're familiar with unix based command line,
via command line, navigate to the project, then run the following commands:

1. $ `docker-compose build app`

2. $ `docker-compose up -d`
    - This will make the docker-compose command to be detached from your terminal session, if you want to run it
      attached, run the command below:
        - $ `docker-compose up`

3. Check if there are two docker processes running in the background, by running:
    - $ `docker ps`
    - In case something is not working, please give a try running the docker-compose attached to see what's the issue.
      If the problem persists, please contact the developer.

4. In case it's your first time running the project, please run the following command:
    - $ `docker exec -it goodnight_app ./bin/setup`
        - This script is idempotent, so even if you run again you'll not lose anything.

5. Access the container for running the server by running:
    - $ `docker exec -it goodnight_app bash`

6. For running the server and making it available on your machine you can run:
    - $ `rsb` (This is an alias for `rails server -b 0.0.0.0`)

<br>

- In case you want to stop the containers you can you can run:
    - $ `docker-compose stop`

<br>

**NOTE**: These instructions are for local usage and development only.