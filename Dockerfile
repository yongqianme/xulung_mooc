FROM ruby:2.1.5

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# ONBUILD COPY Gemfile /usr/src/app/
# ONBUILD COPY Gemfile.lock /usr/src/app/

ADD xulung_app /usr/src/app

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN gem install arel -v '5.0.1.20140414130214'
RUN bundle install
# RUN bundle exec db:migrate 
# RUN bundle exec rake assets:precompile
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
