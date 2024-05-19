# frozen_string_literal: true

require_relative '../../../test_helper'

class ContentTagsFileLinkTest < ActiveSupport::TestCase
  delegate :rails_blob_path, to: 'Rails.application.routes.url_helpers'

  setup do
    @page = occams_cms_pages(:default)
    @file = occams_cms_files(:default)
  end

  # -- Tests -------------------------------------------------------------------

  def test_init
    tag = Occams::Content::Tags::FileLink.new(context: @page, params: ['123'])
    assert_equal '123', tag.identifier
    assert_equal 'url', tag.as
  end

  def test_init_with_params
    tag = Occams::Content::Tags::FileLink.new(
      context: @page,
      params: [
        '123', {
          'as' => 'image',
          'resize' => '100x100',
          'gravity' => 'center',
          'crop' => '100x100+0+0'
        }
      ]
    )
    assert_equal '123', tag.identifier
    assert_equal 'image', tag.as
    assert_equal ({
      'resize' => '100x100',
      'gravity' => 'center',
      'crop' => '100x100+0+0'
    }), tag.variant_attrs
  end

  def test_init_without_identifier
    message = 'Missing identifier for file link tag'
    assert_raises Occams::Content::Tag::Error, message do
      Occams::Content::Tags::FileLink.new(context: @page)
    end
  end

  def test_file
    tag = Occams::Content::Tags::FileLink.new(context: @page, params: [@file.id])
    assert_instance_of Occams::Cms::File, tag.file_record

    tag = Occams::Content::Tags::FileLink.new(context: @page, params: ['invalid'])
    assert_nil tag.file_record
  end

  def test_content
    tag = Occams::Content::Tags::FileLink.new(context: @page, params: [@file.id])
    out = rails_blob_path(tag.file, only_path: true)
    assert_equal out, tag.content
    assert_equal out, tag.render
  end

  def test_content_as_link
    tag = Occams::Content::Tags::FileLink.new(
      context: @page,
      params: [@file.id, { 'as' => 'link', 'class' => 'html-class' }]
    )
    url = rails_blob_path(tag.file, only_path: true)
    out = "<a href='#{url}' class='html-class' target='_blank'>default file</a>"
    assert_equal out, tag.content
    assert_equal out, tag.render
  end

  def test_content_as_image
    tag = Occams::Content::Tags::FileLink.new(
      context: @page,
      params: [@file.id, { 'as' => 'image', 'class' => 'html-class' }]
    )
    url = rails_blob_path(tag.file, only_path: true)
    out = "<img src='#{url}' class='html-class' alt='default file' title='default file'/>"
    assert_equal out, tag.content
    assert_equal out, tag.render
  end

  def test_content_when_not_found
    tag = Occams::Content::Tags::FileLink.new(context: @page, params: ['invalid'])
    assert_equal '', tag.content
    assert_equal '', tag.render
  end
end
