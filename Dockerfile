FROM ruby:3.0
LABEL maintainer="Nouvak <vitornovaes27@gmail.com>"

# Path definition
ENV INSTALL_PATH /acme
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

# Dependences VM install
RUN apt-get update -qq && apt-get install -y build-essential \
  libpq-dev nodejs postgresql-client

# App dependences
COPY Gemfile $INSTALL_PATH/Gemfile
COPY Gemfile.lock $INSTALL_PATH/Gemfile.lock

ENV RAILS_ENV=production

# Dependence install
RUN gem install bundler && \
  bundle install

# Copy relative app files
COPY . $INSTALL_PATH

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
EXPOSE 3000

ENTRYPOINT ["entrypoint.sh"]
