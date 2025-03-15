# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Gymgeniusapi
  class Application < Rails::Application
    config.load_defaults 7.0

    config.session_store :cookie_store, key: '_gym_genius_api_session'
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use config.session_store, config.session_options

    config.api_only = true
    config.autoload_paths += %W[#{config.root}/lib]
  end
end
