FROM ruby:2.7.2

RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       libpq-dev \
                       nodejs

RUN mkdir /myapp

WORKDIR /myapp

ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock

RUN gem install bundler
RUN bundle install

ADD . /myapp

RUN mkdir -p tmp/sockets
RUN mkdir -p tmp/pids
