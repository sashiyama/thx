source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1', '>= 5.1.5'
gem 'puma', '~> 3.11', '>= 3.11.2'
# respond_toが外部Gemになった
gem 'responders', '~> 2.4'
# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.4.10'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0', '>= 5.0.7'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2', '>= 4.2.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# WebAPI
gem 'grape'
gem 'grape-jbuilder'

# curb
gem 'curb'

# メモリ管理
gem 'unicorn-worker-killer'

# error tracking
gem 'airbrake'

# 起動プロセス管理
gem 'foreman'

# 設定管理
gem 'global', '~> 0.2.1'

# 認証
gem 'devise', '~> 4.4', '>= 4.4.1'

# 管理画面
gem 'rails_admin', '~> 1.3'

# 権限管理
gem 'cancan'

# バージョン管理
gem 'paper_trail', '~> 8.1', '>= 8.1.2'
gem 'paranoia', '~> 2.4'

gem "validate_url"

# redis
gem 'redis-objects', '~> 1.4'
gem 'redis-namespace', '~> 1.6'
gem 'redis-rails', '~> 5.0', '>= 5.0.2'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 1.0', group: :doc

# slim
gem 'slim-rails', '~> 3.1', '>= 3.1.3'

# ページネイト
gem 'kaminari'

# jsパラメータ受け渡し
gem 'gon', '~> 6.2'

# ステートマシン
gem 'aasm'

# carrierwave
gem 'carrierwave', '~> 1.2', '>= 1.2.2'
gem 'mini_magick'

# 非同期処理
gem 'sidekiq', '< 5'
gem 'sidekiq-middleware'
# sidekiq/web用
gem 'sinatra', '~> 2.0', '>= 2.0.1', require: nil

# for carrierwave s3
gem 'fog'

# AWS操作
gem 'aws-sdk', '~> 3.0', '>= 3.0.1'
gem 'aws-sdk-rails', '~> 2.0', '>= 2.0.1'

gem 'asset_sync'

# unicode正規化
gem 'unf'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
 gem 'unicorn'

# whenever
gem 'whenever', :require => false

# to use mash
gem 'hashie'

# 環境変数設定
gem 'dotenv-rails', '~> 2.2', '>= 2.2.1'

# ヘルスチェックエンドポイント追加
gem 'komachi_heartbeat', '~> 2.5'

gem "browser"

gem 'html2slim', '~> 0.2.0'

# sitemap.xml
gem "sitemap_generator"

# バルクインサート(アップデート)
gem 'activerecord-import', '~> 0.22.0'

# for turbolinks-escape
#gem 'jquery-turbolinks'

# data作成
gem 'factory_bot_rails', '~> 4.8', '>= 4.8.2'

# log-json整形
gem 'lograge', '~> 0.9.0'
gem 'logstash-event'

# react
gem 'react-rails', '~> 2.4', '>= 2.4.4'

# seed fu
gem 'seed-fu', '~> 2.3', '>= 2.3.7'

# ER図生成
gem 'rails-erd', '~> 1.5', '>= 1.5.2'

# slack通知
gem 'slack-notifier', '~> 2.3', '>= 2.3.2'

gem 'webpacker', '~> 3.2', '>= 3.2.2'

gem 'listen'

group :development, :test do
  gem 'pry-rails'
  gem 'pry-byebug'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # テストdata掃除
  gem 'database_cleaner'

  # rspec
  gem 'rspec-rails', '~> 3.7', '>= 3.7.2'
  gem 'capybara'
  gem 'rspec-json_matcher', '~> 0.1.6'
  gem 'rspec_junit_formatter', '~> 0.2.3'
  gem 'shoulda-matchers'
  ## validatorのspecを簡易化
  gem 'rspec-validator_spec_helper', '~> 1.0'

  # 開発用mailer
  gem 'letter_opener_web', '~> 1.3', '>= 1.3.3'

  gem 'bullet', '~> 5.7', '>= 5.7.3'

  # generate fake data
  gem 'faker', '~> 1.7', '>= 1.7.3'
end

# Access an IRB console on exception pages or by using <%= console %> in views
gem 'web-console', '~> 3.5', '>= 3.5.1', group: :development

gem 'rails-controller-testing', '~> 1.0', '>= 1.0.2', group: :test
