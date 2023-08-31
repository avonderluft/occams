# frozen_string_literal: true

require_relative '../../../test_helper'

class ContentTagsSiblingsTest < ActiveSupport::TestCase
  setup do
    @site   = occams_cms_sites(:default)
    @layout = occams_cms_layouts(:default)
    @page   = occams_cms_pages(:default)
    @first = @site.pages.create!(layout: @layout, parent: @page, label: 'First', slug: 'first')
    @second = @site.pages.create!(layout: @layout, parent: @page, label: 'Second', slug: 'second')
    @third = @site.pages.create!(layout: @layout, parent: @page, label: 'Third', slug: 'third')
    @fourth = @site.pages.create!(layout: @layout, parent: @page, label: 'Fourth', slug: 'fourth')
  end

  def test_init
    tag = Occams::Content::Tag::Siblings.new(
      context: @third,
      params: []
    )
    assert_equal ({}), tag.locals
  end

  def test_init_with_style
    tag = Occams::Content::Tag::Siblings.new(
      context: @third,
      params: [{ 'style' => 'font-weight: bold' }]
    )
    assert_equal '<style>#siblings {font-weight: bold}</style>', tag.style
  end

  def test_render
    tag = Occams::Content::Tag::Siblings.new(
      context: @third,
      params: [{ 'style' => 'font-weight: bold' }]
    )
    html = "<style>#siblings {font-weight: bold}</style><div id=\"siblings\">\
<a href=/second>Second</a> &laquo;&nbsp;<em>Previous</em> \
&bull; <em>Next</em>&nbsp;&raquo; <a href=/fourth>Fourth</a></div>"
    assert_equal html, tag.render
  end
end
