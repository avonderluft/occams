# frozen_string_literal: true

require_relative "../../../test_helper"

class ContentTagsMarkdownTest < ActiveSupport::TestCase

  setup do
    @page = occams_cms_pages(:default)
  end

  def test_init
    tag = Occams::Content::Tag::Markdown.new(context: @page, params: ["test"])
    assert_equal "test", tag.identifier
  end

  def test_content
    frag = occams_cms_fragments(:default)
    tag = Occams::Content::Tag::Markdown.new(context: @page, params: [frag.identifier])
    assert_equal frag,          tag.fragment
    assert_equal frag.content,  tag.content
  end

  def test_render
    frag = occams_cms_fragments(:default)
    frag.update_column(:content, "**test**")
    tag = Occams::Content::Tag::Markdown.new(context: @page, params: [frag.identifier])
    assert_equal "<p><strong>test</strong></p>\n", tag.render
  end

  def test_render_unrenderable
    frag = occams_cms_fragments(:default)
    tag = Occams::Content::Tag::Markdown.new(
      context: @page,
      params: [frag.identifier, { "render" => "false" }]
    )
    assert_equal "", tag.render
  end

end
