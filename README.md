# Goodnight App

## Before starting

**IMPORTANT**

In case you don't want to manually set up the `.env`, you can run the following bash
command: `bin/app/set_default_env` (outside the docker container)
this will set the default environment variables, and set the DB and Cache folder into your `$HOME` directory, so please
remember to delete it later.

Otherwise, please be sure to create an `.env` file before anything else, use `.env.template` as a template for your
environment variables.

In short in the `.env` file you'll set the path for:

- The folder path related to the cache used on bundler.
- The path for the database volume.
- The database settings data such as user, password, host, port, etc.
- The `RAILS_ENV` (If not set, the _default_ value is `development`)

## Running the project using docker

Considering you're familiar with unix based command line,
via command line, navigate to the project, then run the following commands:

1. $ `docker-compose build app`

2. $ `docker-compose up`
    - This will make the docker-compose command to be attached to your terminal session, if you want to run it
      detached, run the command below:
        - $ `docker-compose up -d`
    - Please wait for `goodnight_app` to appear showing the message `== Starting sleep for development ==` in case
      you're running it attached, then (in other terminal) you can proceed to the next step.

3. Check if there are two docker processes running in the background, by running:
    - $ `docker ps`
    - In case something is not working, please give a try running the docker-compose attached to see what's the issue.
      If the problem persists, please contact the developer.

4. In case it's your first time running the project, please run the following command:
    - $ `docker exec -it goodnight_app ./bin/setup`
        - This script is idempotent, so even if you run again you'll not lose or overwrite anything.

5. To start the server without needing to access the docker container you can run
    - $ `bin/app/start_server` (_outside the docker container_)

<br>

- In case you want to stop the containers you can you can run:
    - $ `docker-compose stop`

---

- If you prefer access the container for running the server, then follow the next steps:

1. Access the container for running the server by running:
    - $ `docker exec -it goodnight_app bash`

2. For running the server and making it available on your machine you can run:
    - $ `rsb` (This is an alias for `rails server -b 0.0.0.0`)

<br>

**NOTE**: These instructions are for local usage and development only.

--- 

## Running the test suite

For running the test suite you just need to run the command: `bin/app/run_tests`

Or you can access the bash inside the container and make sure that you're setting `RAILS_ENV=test` when running rspec.

## API Documentation

The API has endpoints that are related to:

- User data
- Sleep logs
- Follower relationships

You can find the available endpoints by importing the Insomnia collection that can be found in `api_doc/`

**NOTES**:

- Users and Sleep logs use UUID as their ID.

- The routes that has `:id` or `:user_id` `:other_user_id`, replace with the UUID of the user.
  You can get an user as example requesting the `GET /api/v1/users` endpoint.

- The default address of the server is going to be at: `localhost:3000/`

- Only the logs from the past 7 days will show up, unless the code is changed at the `SleepLogService` module.
