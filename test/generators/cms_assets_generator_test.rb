# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/generators/occams/cms/assets_generator'

class CmsAssetsGeneratorTest < Rails::Generators::TestCase
  tests Occams::Generators::Cms::AssetsGenerator

  def test_generator
    run_generator
    assert_directory 'app/assets/javascripts/occams/admin/cms'
    assert_directory 'app/assets/stylesheets/occams/admin/cms'
  end
end
