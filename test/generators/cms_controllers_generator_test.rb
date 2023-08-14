# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/generators/occams/cms/controllers_generator'

class CmsControllersGeneratorTest < Rails::Generators::TestCase
  tests Occams::Generators::Cms::ControllersGenerator

  def test_generator
    run_generator
    assert_directory 'app/controllers/occams'
    assert_file 'app/controllers/occams/admin/cms/base_controller.rb'
  end
end
