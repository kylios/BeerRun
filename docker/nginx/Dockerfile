FROM nginx:1.15-alpine
ARG APP_ENV

ADD docker/nginx/nginx.conf.template /tmp/nginx.conf.template

ENV APP_ENV=$APP_ENV
RUN sed "s/:APP_ENV/${APP_ENV}/" < /tmp/nginx.conf.template > /etc/nginx/conf.d/beerrun.conf
