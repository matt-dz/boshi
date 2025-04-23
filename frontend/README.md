# Boshi Frontend

Frontend for [Boshi](https://boshi.deguzman.cloud) - the premier anonymous university exclusive social media built on the AT Protocol.

## Getting Started

Begin by running the command

```bash
cp .env.example .env
```

to copy the environment template locally and set the variables accordingly.

**Note**: You must have the [backend](https://github.com/matt-dz/boshi/tree/main/backend) running locally as well.

Then begin the application by running

```bash
make run
```

This will load the flutter application with your environment variables in `.env` and setup the application on `127.0.0.1:3000` or wherever you specified the frontend port

You can stop the application with `Ctrl + C` or `Q`.
