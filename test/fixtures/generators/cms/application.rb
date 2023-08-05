module TestApp
  class Application < Rails::Application
    # Ensuring that ActiveStorage routes are loaded before Occams's globbing
    # route. Without this file serving routes are inaccessible.
    config.railties_order = [ActiveStorage::Engine, :main_app, :all]
  end
end
