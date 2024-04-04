
FROM ruby:2.4.9-alpine AS GEMS

RUN apk add -y --no-cache \
    postgresql-dev \
    build-base

COPY . /app
WORKDIR /app

RUN bundle install

FROM ruby:2.4.9-alpine 
RUN apk add -y --no-cache \
    postgresql-client 
COPY  --from=GEMS  /usr/local/bundle /usr/local/bundle 
COPY . /app 
WORKDIR /app 
