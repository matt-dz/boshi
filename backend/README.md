# Boshi Backend

## Setup

To run the backend, ensure you have the following installed:

- [Go 1.23](https://go.dev/dl/)
- [Docker](https://docs.docker.com/compose/install/)

Next, copy the `.env.example` file to `.env` and fill in the required environment variables.

Then run the following command to start up the PostgreSQL and Redis instances and the server.

```bash
make run
```

The PostgreSQL and Redis instances are setup via the `docker-compose.yaml` file and can be adjusted to your liking. Be sure to update any necessary variables in `.env` to reflect your changes.

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
