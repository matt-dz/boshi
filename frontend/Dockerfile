# Build flutter project
FROM --platform=$BUILDPLATFORM ghcr.io/cirruslabs/flutter:stable AS build
ARG BUILD_TARGET
ARG BACKEND_BASE_URL
ARG PROD=false
ARG BACKEND_PORT=443
ARG FEED_GENERATOR_URI
WORKDIR /app
COPY . .
RUN flutter build web -t ${BUILD_TARGET} \
    --dart-define=BACKEND_BASE_URL=${BACKEND_BASE_URL} \
    --dart-define=BACKEND_PORT=${BACKEND_PORT} \
    --dart-define=FEED_GENERATOR_URI=${FEED_GENERATOR_URI} \
    --dart-define=PROD=${PROD}

# Serve project with nginx
FROM nginx:alpine
ARG NGINX_HOST
ARG BACKEND_BASE_URL
ARG CLIENT_METADATA_PATH

# Set template variables
ENV NGINX_HOST=${NGINX_HOST}
ENV CLIENT_METADATA_PATH=${CLIENT_METADATA_PATH}
ENV NGINX_PORT=80
ENV ENV=PROD


EXPOSE ${NGINX_PORT}

# Copy nginx files
COPY --from=build /app/build/web /usr/share/nginx/html
COPY --from=build /app/nginx/templates/* /etc/nginx/templates/
COPY --from=build /app/nginx/nginx.conf /etc/nginx/nginx.conf
