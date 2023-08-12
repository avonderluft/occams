# frozen_string_literal: true

require_relative '../../../test_helper'

class ContentTagsAssetTest < ActiveSupport::TestCase
  setup do
    @page = occams_cms_pages(:default)
  end

  def test_init
    tag = Occams::Content::Tag::Asset.new(
      context: @page,
      params: ['default']
    )
    assert_equal 'default', tag.identifier
    assert_nil tag.type
    assert_equal 'url', tag.as
  end

  def test_init_with_params
    tag = Occams::Content::Tag::Asset.new(
      context: @page,
      params: ['default', { 'type' => 'css', 'as' => 'tag' }]
    )
    assert_equal 'default', tag.identifier
    assert_equal 'css', tag.type
    assert_equal 'tag', tag.as
  end

  def test_init_without_identifier
    message = 'Missing layout identifier for asset tag'
    assert_exception_raised Occams::Content::Tag::Error, message do
      Occams::Content::Tag::Asset.new(context: @page)
    end
  end

  def test_layout
    tag = Occams::Content::Tag::Asset.new(context: @page, params: ['default'])
    assert tag.layout.is_a?(Occams::Cms::Layout)
  end

  def test_content_for_invalid
    tag = Occams::Content::Tag::Asset.new(context: @page, params: ['default'])
    assert_nil tag.content
  end

  def test_content_for_css
    tag = Occams::Content::Tag::Asset.new(
      context: @page,
      params: ['default', { 'type' => 'css' }]
    )
    out = "/cms-css/#{@page.site_id}/#{@page.layout.identifier}/#{@page.layout.cache_buster}.css"
    assert_equal out, tag.content
  end

  def test_content_for_css_as_tag
    tag = Occams::Content::Tag::Asset.new(
      context: @page,
      params: ['default', { 'type' => 'css', 'as' => 'tag' }]
    )
    out = "/cms-css/#{@page.site_id}/#{@page.layout.identifier}/#{@page.layout.cache_buster}.css"
    out = "<link href='#{out}' media='screen' rel='stylesheet' type='text/css' />"
    assert_equal out, tag.content
  end

  def test_content_for_css_with_public_cms_path
    Occams.config.public_cms_path = '/custom'
    tag = Occams::Content::Tag::Asset.new(
      context: @page,
      params: ['default', { 'type' => 'css' }]
    )
    out = "/custom/cms-css/#{@page.site_id}/#{@page.layout.identifier}/#{@page.layout.cache_buster}.css"
    assert_equal out, tag.content
  end

  def test_content_for_js
    tag = Occams::Content::Tag::Asset.new(
      context: @page,
      params: ['default', { 'type' => 'js' }]
    )
    out = "/cms-js/#{@page.site_id}/#{@page.layout.identifier}/#{@page.layout.cache_buster}.js"
    assert_equal out, tag.content
  end

  def test_content_for_js_as_tag
    tag = Occams::Content::Tag::Asset.new(
      context: @page,
      params: ['default', { 'type' => 'js', 'as' => 'tag' }]
    )
    out = "/cms-js/#{@page.site_id}/#{@page.layout.identifier}/#{@page.layout.cache_buster}.js"
    out = "<script src='#{out}' type='text/javascript'></script>"
    assert_equal out, tag.content
  end

  def test_content_for_js_with_public_cms_path
    Occams.config.public_cms_path = '/custom'
    tag = Occams::Content::Tag::Asset.new(
      context: @page,
      params: ['default', { 'type' => 'js' }]
    )
    out = "/custom/cms-js/#{@page.site_id}/#{@page.layout.identifier}/#{@page.layout.cache_buster}.js"
    assert_equal out, tag.content
  end
end
