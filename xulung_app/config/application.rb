require File.expand_path('../boot', __FILE__)

require 'rails/all'
require "sprockets/railtie"
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Schulung
  class Application < Rails::Application
    ENV['MAILER_METHOD']    ||= 'sendmail'
    ENV['MAILER_HOST']      ||= 'localhost:3000'
    ENV['MAILER_PROTOCOL']  ||= 'http'

    config.action_mailer.default_url_options = {
      :host =>     ENV['MAILER_HOST'],
      :protocol => ENV['MAILER_PROTOCOL']
    }

    # to_sym is important
    config.action_mailer.delivery_method = ENV['MAILER_METHOD'].to_sym

    if ENV['MAILER_METHOD'] == 'smtp'
      config.action_mailer.smtp_settings = {
        address:      ENV['MAILER_SMTP_SERVER'],
        port:         ENV['MAILER_SMTP_PORT'],
        user_name:    ENV["MAILER_SMTP_USERNAME"],
        password:     ENV["MAILER_SMTP_PASSWORD"],
        authentication: "plain",
        enable_starttls_auto: true
      }
    end

    if ENV['MAILER_METHOD'] == 'mailgun'
      config.action_mailer.mailgun_settings = {
        api_key: ENV['apikey'],
        domain:  ENV['domain']
      }
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.active_record.default_timezone = :local

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    config.i18n.available_locales = [:en, 'zh-CN']
    config.i18n.default_locale = 'zh-CN'
    config.encoding = "utf-8"
    config.generators do |g|
      g.assets false
    end


  ALLOW_LOCALE = Dir["#{Rails.root}/config/locales/*.yml"].map {|f| File.basename(f).split('.').first}
end
end
