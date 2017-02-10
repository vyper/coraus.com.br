# Middleman builder docker image
FROM ruby:2.3.3-slim

# Set environment
ENV DEBIAN_FRONTEND=noninteractive TERM=xterm-color

# Update the package manager
RUN apt-get update

# Install build tools
RUN apt-get install -y build-essential chrpath libssl-dev libxft-dev nodejs curl git

# Install phantomjs for UAT
RUN apt-get install -y libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev
ENV PHANTOM_JS_VERSION="phantomjs-1.9.8-linux-x86_64"
ENV PHANTOM_JS_ARCHIVE_FOLDER="/tmp/${PHANTOM_JS_VERSION}"
ENV PHANTOM_JS_ARCHIVE_PATH="${PHANTOM_JS_ARCHIVE_FOLDER}.tar.bz2"
RUN curl -Lo $PHANTOM_JS_ARCHIVE_PATH https://bitbucket.org/ariya/phantomjs/downloads/$(basename $PHANTOM_JS_ARCHIVE_PATH)
RUN tar -C `dirname $PHANTOM_JS_ARCHIVE_FOLDER` -xvjf $PHANTOM_JS_ARCHIVE_PATH
RUN mv $PHANTOM_JS_ARCHIVE_FOLDER /usr/local/share
RUN ln -sf /usr/local/share/$PHANTOM_JS_VERSION/bin/phantomjs /usr/local/bin

# DevServer Port
EXPOSE 4567

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile* /usr/src/app/
RUN bundle install
