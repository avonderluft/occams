# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/occams/generators/cms/models_generator'

class CmsModelsGeneratorTest < Rails::Generators::TestCase
  tests Occams::Generators::Cms::ModelsGenerator

  def test_generator
    run_generator
    assert_directory 'app/models/occams'
    assert_file 'app/models/occams/cms/page.rb'
  end
end
