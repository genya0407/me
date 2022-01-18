FROM ruby:2.7.5

ENV TZ Asia/Tokyo
RUN apt-get update && apt-get install -y busybox-static

WORKDIR /app

ADD Gemfile /app
ADD Gemfile.lock /app
RUN bundle install
ADD . /app
ADD crontab /var/spool/cron/crontabs/root

