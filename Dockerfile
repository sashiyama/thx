FROM ruby:2.3.6
ENV LANG C.UTF-8
ENV APP_ROOT /thx
WORKDIR $APP_ROOT
RUN apt-get update && \
    apt-get install -y nodejs \
                       npm \
                       mysql-client \
                       redis-tools \
                       imagemagick \
                       libcurl3 \
                       apt-transport-https \
                       graphviz \
                       --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    # set npm
    npm cache clean && \
    npm install n -g && \
    n stable && \
    ln -sf /usr/local/bin/node /usr/bin/node && \
    apt-get purge -y nodejs npm && \
    # install yarn
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install yarn
COPY Gemfile $APP_ROOT
COPY Gemfile.lock $APP_ROOT
COPY package.json $APP_ROOT
COPY yarn.lock $APP_ROOT
RUN \
  #yarn install && \
  gem install bundler && \
  echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc && \
  bundle config --global build.nokogiri --use-system-libraries && \
  bundle config --global jobs 4 && \
  bundle install && \
  rm -rf ~/.gem
COPY . $APP_ROOT

