# frozen_string_literal: true

module Occams
  module Generators
    module Cms
      class ModelsGenerator < Rails::Generators::Base
        source_root File.expand_path(File.join(File.dirname(__FILE__), '../../../../app/models'))

        def generate_models
          directory 'occams', 'app/models/occams'
        end
      end
    end
  end
end
