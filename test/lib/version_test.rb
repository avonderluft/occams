# frozen_string_literal: true

require_relative '../test_helper'

class VersionTest < ActiveSupport::TestCase
  def test_version
    assert_equal 'constant', defined?(Occams::VERSION)
    refute_empty Occams::VERSION
  end
end
