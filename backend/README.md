# Boshi Backend

## Setup

To run the backend, ensure you have [Go 1.23](https://go.dev/dl/) installed and copy the `.env.example` file to `.env` and fill in the required environment variables.

The backend requires a PostgreSQL database and Redis server. You can run the following command via Docker to start both services locally:

```bash
docker compose up -d
```

Adjust the the `docker-compose.yaml` file if you want to change the default ports or database name. Don't forget to change the `.env` file to reflect the changes.

You can stop the services by running:

```bash
docker compose down
```

After setting up the docker services, run the following command to start the server:

```bash
make run
```
