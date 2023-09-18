# frozen_string_literal: true

require_relative '../../../../../test_helper'

class Occams::Admin::Cms::Revisions::PageControllerTest < ActionDispatch::IntegrationTest
  setup do
    @site     = occams_cms_sites(:default)
    @page     = occams_cms_pages(:default)
    @revision = occams_cms_revisions(:page)
  end

  def test_get_index
    r :get, occams_admin_cms_site_page_revisions_path(@site, @page)
    assert_response :redirect
    assert_redirected_to action: :show, id: @revision
  end

  def test_get_index_with_no_revisions
    Occams::Cms::Revision.delete_all
    r :get, occams_admin_cms_site_page_revisions_path(@site, @page)
    assert_response :redirect
    assert_redirected_to edit_occams_admin_cms_site_page_path(@site, @page)
  end

  def test_get_show
    r :get, occams_admin_cms_site_page_revision_path(@site, @page, @revision)
    assert_response :success
    assert assigns(:record)
    assert assigns(:revision)
    assert assigns(:record).is_a?(Occams::Cms::Page)
    assert_template :show
  end

  def test_get_show_for_invalid_record
    r :get, occams_admin_cms_site_page_revision_path(@site, 'invalid', @revision)
    assert_response :redirect
    assert_redirected_to occams_admin_cms_site_pages_path(@site)
    assert_equal 'Record Not Found', flash[:danger]
  end

  def test_get_show_failure
    r :get, occams_admin_cms_site_page_revision_path(@site, @page, 'invalid')
    assert_response :redirect
    assert assigns(:record)
    assert_redirected_to edit_occams_admin_cms_site_page_path(@site, assigns(:record))
    assert_equal 'Revision Not Found', flash[:danger]
  end

  def test_revert
    assert_difference -> { @page.revisions.count } do
      r :patch, revert_occams_admin_cms_site_page_revision_path(@site, @page, @revision)
      assert_response :redirect
      assert_redirected_to edit_occams_admin_cms_site_page_path(@site, @page)
      assert_equal 'Content Reverted', flash[:success]

      @page.reload

      assert_equal [
        { identifier: 'boolean',
          tag: 'checkbox',
          content: nil,
          datetime: nil,
          boolean: true },
        { identifier: 'file',
          tag: 'file',
          content: nil,
          datetime: nil,
          boolean: false },
        { identifier: 'datetime',
          tag: 'datetime',
          content: nil,
          datetime: occams_cms_fragments(:datetime).datetime,
          boolean: false },
        { identifier: 'content',
          tag: 'text',
          content: 'old content',
          datetime: nil,
          boolean: false },
        { identifier: 'title',
          tag: 'text',
          content: 'old title',
          datetime: nil,
          boolean: false }
      ], @page.fragments_attributes
    end
  end
end
