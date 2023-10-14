# frozen_string_literal: true

module Occams
  module Generators
    module Cms
      class ViewsGenerator < Rails::Generators::Base
        source_root File.expand_path(File.join(File.dirname(__FILE__), '../../../../app/views'))

        def generate_views
          directory 'occams', 'app/views/occams'
        end
      end
    end
  end
end
