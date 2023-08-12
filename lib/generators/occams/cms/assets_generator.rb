# frozen_string_literal: true

module Occams
  module Generators
    module Cms
      class AssetsGenerator < Rails::Generators::Base
        source_root File.expand_path(File.join(File.dirname(__FILE__), '../../../../app/assets'))

        def generate_assets
          directory 'javascripts/occams/admin/cms', 'app/assets/javascripts/occams/admin/cms'
          directory 'stylesheets/occams/admin/cms', 'app/assets/stylesheets/occams/admin/cms'
        end
      end
    end
  end
end
