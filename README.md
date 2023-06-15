# Goodnight App

## Before starting

**IMPORTANT**

Please be sure to create an `.env` file before anything else, use `.env.template` as a template for your environment
variables.

In case you don't want to set it up, you can run the following bash command: `bin/app/set_default_env` this will set the
default environment variables, and set the DB and Cache folder into your `$HOME` directory, so please remember to delete
it later.

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
    - $ `bin/app/start_server`

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

## API Documentation

Below is the list of available endpoints. They are related to:

- User data
- Sleep logs
- Follower relationships

**NOTE**:

- Users and Sleep logs use UUID as their ID.

**NOTE 2**:

- The routes that has `:id` or `:user_id` `:other_user_id`, replace with the UUID of the user.
  You can get an user as example requesting the `GET /api/v1/users` endpoint.

### User Endpoints

#### GET /api/v1/users

Returns the list of all users.

#### GET /api/v1/users/:id

Returns a specific user's data.

### SleepLog Endpoints for Following Users

#### GET /api/v1/users/:user_id/relationships/following/sleep_logs

Returns the sleep logs for the users that a specific user is following from the previous week (e.g.,
June 4th to June 11th).

#### GET /api/v1/users/:user_id/relationships/followers/sleep_logs

Returns the sleep logs for the users that are followers of the specific user from the previous week (
e.g., June 4th to June 11th).

(_extra endpoint_)

### SleepLog Endpoints for Clock-In Operations

#### GET /api/v1/users/:user_id/sleep_logs

Returns all sleep logs for a specific user.

#### GET /api/v1/users/:user_id/sleep_logs/last

Returns the latest sleep log for a specific user.

#### POST /api/v1/users/:user_id/sleep_logs

Creates a new sleep log for a specific user, doing a "clock in" operation.
The same endpoint requested again will perform a "clock out" operation.

- In case there is no record, it's going to create a new record, and in case there is a previous "clocked in" operation
  it's going to do the "clock out".

### Follow/Unfollow User Endpoints

#### GET /api/v1/users/:user_id/relationships

Returns the list of all users that a specific user is following or is being followed by.

#### POST /api/v1/users/:user_id/relationships/:other_user_id

Allows a user to follow another user.

`:user_id` is the user who wants to follow, and `:other_user_id` is the user to be followed.

#### DELETE /api/v1/users/:user_id/relationships/:other_user_id

Allows the user to unfollow someone he's following.

`:user_id` is the user who wants to unfollow, and `:other_user_id` is the user to be unfollowed.
