# Build flutter project
FROM --platform=$BUILDPLATFORM ghcr.io/cirruslabs/flutter:stable AS build
ARG BUILD_TARGET
WORKDIR /app
COPY . .
RUN flutter build web -t $BUILD_TARGET


# Serve project with nginx
FROM nginx:alpine
ARG NGINX_HOST
EXPOSE $NGINX_PORT

# Copy nginx files
COPY --from=build /app/build/web /usr/share/nginx/html
COPY --from=build /app/nginx/templates/* /etc/nginx/templates/
COPY --from=build /app/nginx/nginx.conf /etc/nginx/nginx.conf

# Set template variables
ENV NGINX_HOST=$NGINX_HOST
ENV NGINX_PORT=80
