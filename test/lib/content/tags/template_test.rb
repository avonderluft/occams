# frozen_string_literal: true

require_relative "../../../test_helper"

class ContentTagsTemplateTest < ActiveSupport::TestCase
  def test_init
    tag = Occams::Content::Tag::Template.new(
      context: @page,
      params: ["path/to/template"]
    )
    assert_equal "path/to/template", tag.path
  end

  def test_init_without_path
    message = "Missing template path for template tag"
    assert_exception_raised Occams::Content::Tag::Error, message do
      Occams::Content::Tag::Template.new(context: @page)
    end
  end

  def test_content
    tag = Occams::Content::Tag::Template.new(
      context: @page,
      params: ["path/to/template"]
    )
    assert_equal "<%= render template: \"path/to/template\" %>", tag.content
  end

  def test_render
    tag = Occams::Content::Tag::Template.new(
      context: @page,
      params: ["path/to/template"]
    )
    assert_equal "<%= render template: \"path/to/template\" %>", tag.render
  end

  def test_render_with_whitelist
    Occams.config.allowed_templates = ["allowed/path"]
    tag = Occams::Content::Tag::Template.new(
      context: @page,
      params: ["allowed/path"]
    )
    assert_equal "<%= render template: \"allowed/path\" %>", tag.render

    tag = Occams::Content::Tag::Template.new(
      context: @page,
      params: ["not_allowed/path"]
    )
    assert_equal "", tag.render
  end

  def test_render_with_erb_injection
    tag = Occams::Content::Tag::Template.new(
      context: @page,
      params: ["va\#{:l}ue"]
    )
    assert_equal "<%= render template: \"va\\\#{:l}ue\" %>", tag.render
  end
end
