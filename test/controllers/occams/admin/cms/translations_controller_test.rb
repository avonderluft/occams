# frozen_string_literal: true

require_relative "../../../../test_helper"

class Occams::Admin::Cms::TranslationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @site         = occams_cms_sites(:default)
    @layout       = occams_cms_layouts(:default)
    @page         = occams_cms_pages(:default)
    @translation  = occams_cms_translations(:default)
  end

  def test_get_new
    r :get, new_occams_admin_cms_site_page_translation_path(@site, @page)
    assert_response :success
    assert assigns(:translation)
    assert_template :new
    assert_select "form[action='/admin/sites/#{@site.id}/pages/#{@page.id}/translations']"
  end

  def test_get_new_with_field_wysiwyg
    @layout.update_column(:content, "{{cms:wysiwyg test}}")
    r :get, new_occams_admin_cms_site_page_translation_path(@site, @page)
    assert_response :success
    assert_select "textarea[name='translation[fragments_attributes][0][content]'][data-cms-rich-text]"
    assert_select "input[type='hidden'][name='translation[fragments_attributes][0][identifier]'][value='test']"
    assert_select "input[type='hidden'][name='translation[fragments_attributes][0][tag]'][value='wysiwyg']"
  end

  def test_get_edit
    r :get, edit_occams_admin_cms_site_page_translation_path(@site, @page, @translation)
    assert_response :success
    assert assigns(:translation)
    assert_template :edit
    assert_select "form[action='/admin/sites/#{@site.id}/pages/#{@page.id}/translations/#{@translation.id}']"
  end

  def test_get_edit_failure
    r :get, edit_occams_admin_cms_site_page_translation_path(@site, @page, "invalid")
    assert_response :redirect
    assert_redirected_to edit_occams_admin_cms_site_page_path(@site, @page)
    assert_equal "Translation not found", flash[:danger]
  end

  def test_create
    assert_difference -> { Occams::Cms::Translation.count } do
      path = occams_admin_cms_site_page_translations_path(@site, @page)
      r :post, path, params: { translation: {
        locale: "es",
        label: "Test Translation"
      } }
      assert_response :redirect
      translation = Occams::Cms::Translation.last
      assert_equal @page, translation.page
      assert_redirected_to action: :edit, id: translation
      assert_equal "Translation created", flash[:success]
    end
  end

  def test_creation_failure
    assert_no_difference -> { Occams::Cms::Translation.count } do
      path = occams_admin_cms_site_page_translations_path(@site, @page)
      r :post, path, params: { translation: {} }
      assert_response :success
      assert_template :new
      assert_equal "Failed to create translation", flash[:danger]
    end
  end

  def test_update
    path = occams_admin_cms_site_page_translation_path(@site, @page, @translation)
    r :put, path, params: { translation: {
      label: "Updated Translation"
    } }
    assert_response :redirect
    assert_redirected_to action: :edit, site_id: @site, page_id: @page, id: @translation
    assert_equal "Translation updated", flash[:success]
    @translation.reload
    assert_equal "Updated Translation", @translation.label
  end

  def test_update_failure
    path = occams_admin_cms_site_page_translation_path(@site, @page, @translation)
    r :put, path, params: { translation: {
      locale: ""
    } }
    assert_response :success
    assert_template :edit
    @translation.reload
    assert_not_equal "", @translation.locale
    assert_equal "Failed to update translation", flash[:danger]
  end

  def test_destroy
    assert_difference(-> { Occams::Cms::Translation.count }, -1) do
      r :delete, occams_admin_cms_site_page_translation_path(@site, @page, @translation)
      assert_response :redirect
      assert_redirected_to edit_occams_admin_cms_site_page_path(@site, @page)
      assert_equal "Translation deleted", flash[:success]
    end
  end

  def test_get_form_fragments
    path = form_fragments_occams_admin_cms_site_page_translation_path(@site, @page, @translation)
    r :get, path, xhr: true, params: {
      layout_id: occams_cms_layouts(:nested).id
    }
    assert_response :success
    assert assigns(:translation)
    assert_equal 2, assigns(:translation).fragment_nodes.size
    assert_template "occams/admin/cms/fragments/_form_fragments"

    r :get, path, xhr: true, params: {
      layout_id: @layout.id
    }
    assert_response :success
    assert assigns(:translation)
    assert_equal 1, assigns(:translation).fragment_nodes.size
    assert_template "occams/admin/cms/fragments/_form_fragments"
  end

  def test_get_form_fragments_for_new_translation
    path = form_fragments_occams_admin_cms_site_page_translation_path(@site, @page, 0)
    r :get, path, xhr: true, params: {
      layout_id: @layout.id
    }
    assert_response :success
    assert assigns(:translation)
    assert_equal 1, assigns(:translation).fragment_nodes.size
    assert_template "occams/admin/cms/fragments/_form_fragments"
  end

  def test_creation_preview
    assert_no_difference -> { Occams::Cms::Translation.count } do
      r :post, occams_admin_cms_site_page_translations_path(@site, @page), params: {
        preview: "Preview",
        translation: {
          label: "Test Page",
          layout_id: @layout.id,
          locale: "fr",
          fragments_attributes: [
            { identifier: "content",
              content: "preview content" }
          ]
        }
      }
      assert_response :success
      assert_match %r{preview content}, response.body
      assert_equal "text/html", response.content_type

      assert_equal @site, assigns(:cms_site)
      assert_equal @layout, assigns(:cms_layout)
      assert assigns(:cms_page)
      assert assigns(:translation).new_record?

      assert_equal :fr, I18n.locale
    end
  end

  def test_update_preview
    assert_no_difference -> { Occams::Cms::Page.count } do
      r :put, occams_admin_cms_site_page_translation_path(@site, @page, @translation), params: {
        preview: "Preview",
        translation: {
          label: "Updated Label",
          fragments_attributes: [
            { identifier: "content",
              content: "preview content" }
          ]
        }
      }
      assert_response :success
      assert_match %r{preview content}, response.body
      @translation.reload
      assert_not_equal "Updated Label", @page.label

      assert_equal @page.site,    assigns(:cms_site)
      assert_equal @page.layout,  assigns(:cms_layout)
      assert_equal @page,         assigns(:cms_page)
    end
  end
end
