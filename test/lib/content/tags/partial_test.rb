# frozen_string_literal: true

require_relative "../../../test_helper"

class ContentTagsPartialTest < ActiveSupport::TestCase
  def test_init
    tag = Occams::Content::Tag::Partial.new(
      context: @page,
      params: ["path/to/partial"]
    )
    assert_equal "path/to/partial", tag.path
    assert_equal ({}), tag.locals
  end

  def test_init_with_locals
    tag = Occams::Content::Tag::Partial.new(
      context: @page,
      params: ["path/to/partial", { "key" => "val" }]
    )
    assert_equal "path/to/partial", tag.path
    assert_equal ({ "key" => "val" }), tag.locals
  end

  def test_init_without_path
    message = "Missing path for partial tag"
    assert_exception_raised Occams::Content::Tag::Error, message do
      Occams::Content::Tag::Partial.new(
        context: @page,
        params: [{ "key" => "val" }]
      )
    end
  end

  def test_content
    tag = Occams::Content::Tag::Partial.new(
      context: @page,
      params: ["path/to/partial", { "key" => "val" }]
    )
    assert_equal "<%= render partial: \"path/to/partial\", locals: {\"key\"=>\"val\"} %>", tag.content
  end

  def test_render
    tag = Occams::Content::Tag::Partial.new(
      context: @page,
      params: ["path/to/partial", { "key" => "val" }]
    )
    assert_equal "<%= render partial: \"path/to/partial\", locals: {\"key\"=>\"val\"} %>", tag.render
  end

  def test_render_with_whitelist
    Occams.config.allowed_partials = ["safe/path"]

    tag = Occams::Content::Tag::Partial.new(
      context: @page,
      params: ["path/to/partial"]
    )
    assert_equal "", tag.render

    tag = Occams::Content::Tag::Partial.new(
      context: @page,
      params: ["safe/path"]
    )
    assert_equal "<%= render partial: \"safe/path\", locals: {} %>", tag.render
  end

  def test_render_with_erb_injection
    tag = Occams::Content::Tag::Partial.new(
      context: @page,
      params: ["foo\#{:bar}", { "key" => "va\#{:l}ue" }]
    )
    assert_equal "<%= render partial: \"foo\\\#{:bar}\", locals: {\"key\"=>\"va\\\#{:l}ue\"} %>", tag.render
  end
end
