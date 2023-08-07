# frozen_string_literal: true

require_relative "../../../test_helper"

class ContentTagsDateTest < ActiveSupport::TestCase
  setup do
    @page = occams_cms_pages(:default)
  end

  def test_init
    tag = Occams::Content::Tag::Date.new(context: @page, params: ["test"])
    assert_equal "test", tag.identifier
  end

  def test_content
    frag = occams_cms_fragments(:datetime)
    tag = Occams::Content::Tag::Date.new(context: @page, params: [frag.identifier])
    assert_equal frag,          tag.fragment
    assert_equal frag.datetime, tag.content
  end
end
