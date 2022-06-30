FROM ruby:3.0.4
ENV LANG C.UTF-8

# ENV
ENV R_PREFIX portcurio

RUN apt-get update -qq && apt-get install -y build-essential \
                                             libpq-dev \
                                             nodejs && \
curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
apt-get install -y nodejs && \
apt-get update && apt-get install -y curl apt-transport-https wget && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn && \
apt-get update && apt-get install -y mariadb-client

RUN mkdir /$R_PREFIX
WORKDIR /$R_PREFIX

ADD Gemfile /$R_PREFIX/Gemfile
ADD Gemfile.lock /$R_PREFIX/Gemfile.lock

RUN gem install bundler:2.3.12
RUN bundle install
RUN yarn add @fortawesome/fontawesome-free

ADD . /$R_PREFIX

# Nginxと通信を行うための準備
RUN mkdir -p tmp/sockets
RUN mkdir -p tmp/pids

VOLUME /$R_PREFIX/public
VOLUME /$R_PREFIX/tmp

RUN yarn install --check-files

# アセットのプリコンパイル
RUN SECRET_KEY_BASE=placeholder bundle exec rails assets:precompile \
 && yarn cache clean \
 && rm -rf node_modules tmp/cache