require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Thx
  class Application < Rails::Application
    # 依存対策
    Global.configure do |config|
      config.environment      = Rails.env.to_s
      config.config_directory = Rails.root.join('config/global').to_s
    end
    ActiveSupport::Dependencies.autoload_paths << 'lib'
    config.autoload_paths += %W(#{config.root}/lib/autoload)

    def Rails.development?
      return Rails.env == 'development'
    end
    def Rails.test?
      return Rails.env == 'test'
    end
    def Rails.staging?
      return Rails.env == 'staging'
    end
    def Rails.production?
      return Rails.env == 'production'
    end
    def Rails.debug?
      return (Rails.development? or Rails.test?)
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]

    config.middleware.use(Rack::Config) do |env|
      env['api.tilt.root'] = Rails.root.join 'app', 'views', 'api'
    end

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Tokyo'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    # ヘルスチェック用
    config.heartbeat.application_version = '1.0.0'
    config.heartbeat.application_name = ['thx', Rails.env].join('_')
    config.heartbeat.db_check_enabled = true

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end

