# frozen_string_literal: true

require_relative '../../../test_helper'

class ContentTagsFileTest < ActiveSupport::TestCase
  delegate  :rails_blob_path,
            :rails_representation_path,
            to: 'Rails.application.routes.url_helpers'

  setup do
    @page = occams_cms_pages(:default)
  end

  # -- Tests -------------------------------------------------------------------

  def test_init
    tag = Occams::Content::Tags::File.new(context: @page, params: ['test'])
    assert_equal 'test',  tag.identifier
    assert_equal 'url',   tag.as
  end

  def test_init_with_params
    tag = Occams::Content::Tags::File.new(
      context: @page,
      params: ['test', {
        'as' => 'image',
        'resize' => '100x100',
        'gravity' => 'center',
        'crop' => '100x100+0+0'
      }]
    )
    assert_equal 'test',  tag.identifier
    assert_equal 'image', tag.as
    assert_equal ({
      'resize' => '100x100',
      'gravity' => 'center',
      'crop' => '100x100+0+0'
    }), tag.variant_attrs
  end

  def test_content
    frag = occams_cms_fragments(:file)
    tag = Occams::Content::Tags::File.new(context: @page, params: [frag.identifier])
    assert_equal rails_blob_path(frag.attachments.first, only_path: true), tag.content
  end

  def test_content_as_link
    frag = occams_cms_fragments(:file)
    tag = Occams::Content::Tags::File.new(
      context: @page,
      params: [frag.identifier, { 'as' => 'link', 'class' => 'html-class' }]
    )

    path  = rails_blob_path(frag.attachments.first, only_path: true)
    out   = "<a href='#{path}' class='html-class' target='_blank'>fragment.jpeg</a>"
    assert_equal out, tag.content
  end

  def test_content_as_image
    frag = occams_cms_fragments(:file)
    tag = Occams::Content::Tags::File.new(
      context: @page,
      params: [frag.identifier, { 'as' => 'image', 'class' => 'html-class' }]
    )
    path  = rails_blob_path(frag.attachments.first, only_path: true)
    out   = "<img src='#{path}' class='html-class' alt='fragment.jpeg'/>"
    assert_equal out, tag.content
  end

  def test_content_as_image_with_variant
    frag = occams_cms_fragments(:file)
    tag = Occams::Content::Tags::File.new(
      context: @page,
      params: [frag.identifier, { 'as' => 'image', 'resize' => '50x50' }]
    )
    variant = frag.attachments.first.variant(combine_options: { 'resize' => '50x50' })
    path    = rails_representation_path(variant, only_path: true)
    out     = "<img src='#{path}' alt='fragment.jpeg'/>"
    assert_equal out, tag.content
  end

  def test_content_with_no_attachment
    tag = Occams::Content::Tags::File.new(context: @page, params: ['test'])
    assert_equal '', tag.content
  end
end
