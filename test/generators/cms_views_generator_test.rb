# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/generators/occams/cms/views_generator'

class CmsViewsGeneratorTest < Rails::Generators::TestCase
  tests Occams::Generators::Cms::ViewsGenerator

  def test_generator
    run_generator
    assert_directory 'app/views/occams'
    assert_file 'app/views/occams/admin/cms/pages/index.html.haml'
  end
end
