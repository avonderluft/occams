# frozen_string_literal: true

require "occams"
require "rails"
require "rails-i18n"
require "comfy_bootstrap_form"
require "active_link_to"
require "kramdown"
require "jquery-rails"
require "haml-rails"
require "sassc-rails"

module Occams
  class Engine < ::Rails::Engine

    initializer "occams.setup_assets" do
      ::Occams::Engine.config.assets.precompile += %w[
        occams/admin/cms/application.js
        occams/admin/cms/application.css
        occams/admin/cms/lib/redactor-font.eot
      ]
    end

    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/occams/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end

  end
end
