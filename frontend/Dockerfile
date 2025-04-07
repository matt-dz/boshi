# Build flutter project
FROM --platform=$BUILDPLATFORM ghcr.io/cirruslabs/flutter:stable AS build
ARG BUILD_TARGET
ARG BACKEND_BASE_URL
ARG BACKEND_PORT=443
WORKDIR /app
COPY . .
RUN flutter build web -t ${BUILD_TARGET} \
    --dart-define=BACKEND_BASE_URL=${BACKEND_BASE_URL} \
    --dart-define=BACKEND_PORT=${BACKEND_PORT}


# Serve project with nginx
FROM nginx:alpine
ARG NGINX_HOST
ARG BACKEND_BASE_URL

# Set template variables
ENV NGINX_HOST=${NGINX_HOST}
ENV CLIENT_METADATA_PATH=${BACKEND_BASE_URL}/client-metadata.json
ENV NGINX_PORT=80
ENV ENV=PROD


EXPOSE ${NGINX_PORT}

# Copy nginx files
COPY --from=build /app/build/web /usr/share/nginx/html
COPY --from=build /app/nginx/templates/* /etc/nginx/templates/
COPY --from=build /app/nginx/nginx.conf /etc/nginx/nginx.conf
