# frozen_string_literal: true

# Loading engine only if this is not a standalone installation
unless defined? Occams::Application
  require_relative 'occams/engine'
end

require_relative 'occams/version'
require_relative 'occams/error'
require_relative 'occams/configuration'
require_relative 'occams/routing'
require_relative 'occams/access_control/admin_authentication'
require_relative 'occams/access_control/admin_authorization'
require_relative 'occams/access_control/public_authentication'
require_relative 'occams/access_control/public_authorization'
require_relative 'occams/render_methods'
require_relative 'occams/view_hooks'
require_relative 'occams/form_builder'
require_relative 'occams/seeds'
require_relative 'occams/seeds/layout/importer'
require_relative 'occams/seeds/layout/exporter'
require_relative 'occams/seeds/page/importer'
require_relative 'occams/seeds/page/exporter'
require_relative 'occams/seeds/snippet/importer'
require_relative 'occams/seeds/snippet/exporter'
require_relative 'occams/seeds/file/importer'
require_relative 'occams/seeds/file/exporter'
require_relative 'occams/content'
require_relative 'occams/extensions'

module Occams
  Version = Occams::VERSION

  class << self
    attr_writer :logger

    # Modify CMS configuration
    # Example:
    #   Occams.configure do |config|
    #     config.cms_title = 'Occams'
    #   end
    def configure
      yield configuration
    end

    # Accessor for Occams::Configuration
    def configuration
      @configuration ||= Configuration.new
    end
    alias config configuration

    def logger
      @logger ||= Rails.logger
    end
  end
end
