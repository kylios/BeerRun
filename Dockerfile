FROM ubuntu:16.04
ARG BUILD_ENV

RUN apt-get update && apt-get install -y --allow-unauthenticated rsync

ADD dart-sdk /usr/

RUN mkdir /app
WORKDIR /app

ADD pubspec.* /app/
RUN pub get
ADD . /app/
RUN pub get --offline

WORKDIR /app/tool

RUN echo "BUILDING ENVIRONMENT: $BUILD_ENV"
ENV BUILD_ENV=$BUILD_ENV
ENTRYPOINT /usr/bin/dart build.dart "${BUILD_ENV}"
