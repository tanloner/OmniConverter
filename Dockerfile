FROM instrumentisto/flutter:3.41 AS build-env

WORKDIR /app


COPY . .
RUN flutter pub get
RUN flutter build web

FROM nginx:1.21.1-alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html