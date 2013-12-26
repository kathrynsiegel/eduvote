require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'twilio-ruby'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module KathrynsiegelCmobrienQuiAnnietang92Final
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.assets.version = '1.0'

    # put your own credentials here
    account_sid = 'AC282d3459f9f433ad7578a0621b3e6669'
    auth_token = '7321a55ba898fb87224757cf1a1d71c4'

    # set up a client to talk to the Twilio REST API
    config.client = Twilio::REST::Client.new account_sid, auth_token
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| 
        "#{html_tag}".html_safe 
    }
  end
end


