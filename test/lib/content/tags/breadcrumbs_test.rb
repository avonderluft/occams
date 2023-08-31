# frozen_string_literal: true

require_relative '../../../test_helper'

class ContentTagsBreadcrumbsTest < ActiveSupport::TestCase
  setup do
    @site   = occams_cms_sites(:default)
    @layout = occams_cms_layouts(:default)
    @page   = occams_cms_pages(:default)
    @child = @site.pages.create!(layout: @layout, parent: @page, label: 'Child', slug: 'child')
    @gr_child = @site.pages.create!(layout: @layout, parent: @child, label: 'Gr-child', slug: 'gr-child')
    @gr_gr_child = @site.pages.create!(layout: @layout, parent: @gr_child, label: 'Gr-Gr-child', slug: 'gr-gr-child')
  end

  def test_init
    tag = Occams::Content::Tag::Breadcrumbs.new(
      context: @gr_gr_child,
      params: []
    )
    assert_equal ({}), tag.locals
  end

  def test_init_with_style
    tag = Occams::Content::Tag::Breadcrumbs.new(
      context: @gr_gr_child,
      params: [{ 'style' => 'font-weight: bold' }]
    )
    assert_equal '<style>#breadcrumbs {font-weight: bold}</style>', tag.style
  end

  def test_render
    tag = Occams::Content::Tag::Breadcrumbs.new(
      context: @gr_gr_child,
      params: [{ 'style' => 'font-weight: bold' }]
    )
    html = "<style>#breadcrumbs {font-weight: bold}</style>\
<div id=\"breadcrumbs\"><a href=/>Default Page</a> &raquo; <a href=/child>Child</a> &raquo; \
<a href=/child/gr-child>Gr-child</a> &raquo; Gr-Gr-child</div>"
    assert_equal html, tag.render
  end
end
