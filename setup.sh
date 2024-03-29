#!/bin/sh

export $(cat .env | xargs)
export DATABASE_URL=postgres://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME
bundle exec rake db:create &&
bundle exec rake db:migrate && 
bundle exec rake db:seed 
bundle exec rspec
bundle exec rackup --port $APP_PORT --host $APP_HOST