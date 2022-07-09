FROM ruby:3.0.4
ENV LANG C.UTF-8
RUN apt-get update -qq && apt-get install -y build-essential \
                                             libpq-dev \
                                             nodejs && \
curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
apt-get install -y nodejs && \
apt-get update && apt-get install -y curl apt-transport-https wget && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn && \
apt-get update && apt-get install -y mariadb-client && \
# cronインストール
apt-get update && apt-get install -y cron   

# ENV
ENV APP_PATH /portcurio

RUN mkdir $APP_PATH
WORKDIR $APP_PATH

ADD Gemfile $APP_PATH/Gemfile
ADD Gemfile.lock $APP_PATH/Gemfile.lock

RUN gem install bundler:2.3.12
RUN bundle install
RUN yarn add @fortawesome/fontawesome-free

ADD . $APP_PATH

RUN mkdir -p tmp/sockets

# cronの起動
RUN service cron start
# # wheneverでcrontab書き込み
RUN bundle exec whenever --update-crontab
# # cronをフォアグラウンド実行
CMD ["cron", "-f"]