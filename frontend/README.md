# Boshi Frontend

Boshi frontend built with Flutter.

## Dependencies

- [Flutter](https://docs.flutter.dev/get-started/install)
- [entr](https://github.com/eradman/entr)

## Development

To simply run the application in development, run:

```bash
make run
```

This will start the flutter application on chrome and sets up `entr` to hot reload the application whenever a file in `lib/` changes.

## Docker setup

To setup the frontend with Docker, first create the network with the command

```bash
make docker-network
```

Next, build the docker image with

```bash
docker compose build
```

Finally, run the compose file with

```bash
make dev
```

This setup is useful if you would like to test the changes before pushing them to prod.

To stop the services, run

```bash
make clean
```
