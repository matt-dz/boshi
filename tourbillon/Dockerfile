# Stage 1: Build the SvelteKit application
FROM --platform=$BUILDPLATFORM node:latest AS build
WORKDIR /app
COPY package*.json ./
COPY . .

RUN npm ci
RUN npm run build
RUN npm prune --production

# Stage 2: Serve the application
FROM node:current-alpine
WORKDIR /app
COPY --from=build /app/dist ./dist/
COPY --from=build /app/package.json ./package.json
COPY --from=build /app/node_modules ./node_modules
EXPOSE 3000

# Start the SvelteKit application
CMD ["node", "dist"]
