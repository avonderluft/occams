require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Occams
  class Application < Rails::Application
    require_relative '../lib/occams'

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    # Ensuring that all ActiveStorage routes are loaded before out globbing route.
    config.railties_order = [ActiveStorage::Engine, :main_app, :all]

    # Making sure we don't load our dev routes as part of the engine
    config.paths['config/routes.rb'] << 'config/cms_routes.rb'

    config.i18n.enforce_available_locales = true

    config.active_record.yaml_column_permitted_classes = [Symbol, Date, Time, ActiveSupport::TimeWithZone, ActiveSupport::TimeZone]
  end
end
