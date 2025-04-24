# Boshi Explorer

## Dependencies

- [Go 1.23](https://go.dev/dl/)
- [Docker](https://docs.docker.com/compose/install/)

## Setup

Next, copy the `.env.example` file to `.env` and fill in the required environment variables.

Then run the following command to run the standalone server.

```bash
make run
```

Be sure to have a PostgreSQL instance up if you run the server independently.

## Docker setup

Build the application using docker by running the command:

```bash
make docker
```
