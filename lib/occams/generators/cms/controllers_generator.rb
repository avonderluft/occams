# frozen_string_literal: true

module Occams
  module Generators
    module Cms
      class ControllersGenerator < Rails::Generators::Base
        source_root File.expand_path(File.join(File.dirname(__FILE__), '../../../../app/controllers'))

        def generate_controllers
          directory 'occams', 'app/controllers/occams'
        end
      end
    end
  end
end
