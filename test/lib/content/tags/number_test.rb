# frozen_string_literal: true

require_relative '../../../test_helper'

class ContentTagsNumberTest < ActiveSupport::TestCase
  setup do
    @page = occams_cms_pages(:default)
  end

  def test_init
    tag = Occams::Content::Tags::Number.new(context: @page, params: ['test'])
    assert_equal 'test', tag.identifier
  end
end
