# Boshi Backend

## Dependencies

- [Go 1.23](https://go.dev/dl/)
- [Docker](https://docs.docker.com/compose/install/)

## Setup

Next, copy the `.env.example` file to `.env` and fill in the required environment variables.

Then run the following command to run the standalone server.

```bash
make run
```

Be sure to have a PostgreSQL and Redis instance up if you run the server independently.

## Docker setup

You can set the backend up with docker to connect it with the frontend and test the full application locally. First, setup the docker network if you haven't already with the command:

```bash
make docker-network
```

The PostgreSQL and Redis instances are setup via the `docker-compose.yaml` file and can be adjusted to your liking. Be sure to update any necessary variables in `.env` to reflect your changes. Next, start the services with the command:

```bash
make dev
```

## Stop

To stop the services, run

```bash
make stop
```

This stops the services started in the setup step.

## Restart

If you have made any changes to `schema.sql` and would like them to be reflected in the PostgreSQL instance, you may wipe the instances clean with

```bash
make clean
```

which removes any associated volumes with the database instances (and cleans the `/bin` folder). Running `make run` again will start the PostgreSQL instance with the new schema.
