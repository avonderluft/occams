# frozen_string_literal: true

require_relative "../test_helper"

class AccessControlTest < ActionDispatch::IntegrationTest
  module TestAuthentication
    module Authenticate
      def authenticate
        render plain: "Test Login Denied", status: :unauthorized
      end
    end

    # faking Occams.config.admin_auth = 'AccessControlTest::TestAuthentication'
    # faking Occams.config.public_auth = 'AccessControlTest::TestAuthentication'
    class SitesController   < Occams::Admin::Cms::SitesController; include Authenticate; end
    class ContentController < Occams::Cms::ContentController;      include Authenticate; end
  end

  module TestAuthorization
    module Authorize
      def authorize
        @authorization_vars = instance_variables
        render plain: "Test Access Denied", status: :forbidden
      end
    end

    # faking Occams.config.admin_authorization = 'AccessControlTest::TestAuthorization'
    # faking Occams.config.public_authorization = 'AccessControlTest::TestAuthorization'
    class SitesController         < Occams::Admin::Cms::SitesController;             include Authorize; end
    class LayoutsController       < Occams::Admin::Cms::LayoutsController;           include Authorize; end
    class PagesController         < Occams::Admin::Cms::PagesController;             include Authorize; end
    class SnippetsController      < Occams::Admin::Cms::SnippetsController;          include Authorize; end
    class FilesController         < Occams::Admin::Cms::FilesController;             include Authorize; end
    class CategoriesController    < Occams::Admin::Cms::CategoriesController;        include Authorize; end
    class RevisionsController     < Occams::Admin::Cms::Revisions::LayoutController; include Authorize; end
    class TranslationsController  < Occams::Admin::Cms::TranslationsController;      include Authorize; end
    class ContentController       < Occams::Cms::ContentController;                  include Authorize; end
  end

  # -- Tests -------------------------------------------------------------------
  def test_admin_authentication_default
    assert_equal "Occams::AccessControl::AdminAuthentication",
                 Occams.config.admin_auth

    get occams_admin_cms_sites_path
    assert_response :unauthorized

    r :get, occams_admin_cms_sites_path
    assert_response :success
  end

  def test_admin_authentication_custom
    with_routing do |routes|
      routes.draw do
        get "/admin/sites" => "access_control_test/test_authentication/sites#index"
      end

      get "/admin/sites"
      assert_response :unauthorized
      assert_equal "Test Login Denied", response.body
    end
  end

  def test_admin_authorization_default
    assert_equal "Occams::AccessControl::AdminAuthorization",
                 Occams.config.admin_authorization

    Occams::Admin::Cms::BaseController.include Occams::AccessControl::AdminAuthorization
    r :get, "/admin/sites/#{occams_cms_sites(:default).to_param}/edit"
    assert_response :success, response.body
  end

  def test_admin_authorization_custom
    site = occams_cms_sites(:default)
    with_routing do |routes|
      routes.draw do
        s   = "/admin/sites"
        ns  = "access_control_test/test_authorization"
        get "#{s}/:id/edit"                                       => "#{ns}/sites#edit"
        get "#{s}/:site_id/layouts/:id/edit"                      => "#{ns}/layouts#edit"
        get "#{s}/:site_id/layouts/:layout_id/revisions/:id"      => "#{ns}/revisions#show"
        get "#{s}/:site_id/pages/:id/edit"                        => "#{ns}/pages#edit"
        get "#{s}/:site_id/pages/:page_id/translations/:id/edit"  => "#{ns}/pages#edit"
        get "#{s}/:site_id/snippets/:id/edit"                     => "#{ns}/snippets#edit"
        get "#{s}/:site_id/files/:id/edit"                        => "#{ns}/files#edit"
        get "#{s}/:site_id/categories/:id/edit"                   => "#{ns}/categories#edit"
      end

      r :get, "/admin/sites/#{site.id}/edit"
      assert_response :forbidden
      assert_equal "Test Access Denied", response.body
      assert assigns(:authorization_vars)
      assert assigns(:authorization_vars).member?(:@site)

      layout = occams_cms_layouts(:default)
      r :get, "/admin/sites/#{site.id}/layouts/#{layout.id}/edit"
      assert assigns(:authorization_vars).member?(:@site)
      assert assigns(:authorization_vars).member?(:@layout)

      revision = occams_cms_revisions(:layout)
      r :get, "/admin/sites/#{site.id}/layouts/#{layout.id}/revisions/#{revision.id}"
      assert assigns(:authorization_vars).member?(:@site)
      assert assigns(:authorization_vars).member?(:@record)

      page = occams_cms_pages(:default)
      r :get, "/admin/sites/#{site.id}/pages/#{page.id}/edit"
      assert assigns(:authorization_vars).member?(:@site)
      assert assigns(:authorization_vars).member?(:@page)

      translation = occams_cms_translations(:default)
      r :get, "/admin/sites/#{site.id}/pages/#{page.id}/translations/#{translation.id}/edit"
      assert assigns(:authorization_vars).member?(:@site)
      assert assigns(:authorization_vars).member?(:@page)

      snippet = occams_cms_snippets(:default)
      r :get, "/admin/sites/#{site.id}/snippets/#{snippet.id}/edit"
      assert assigns(:authorization_vars).member?(:@site)
      assert assigns(:authorization_vars).member?(:@snippet)

      file = occams_cms_files(:default)
      r :get, "/admin/sites/#{site.id}/files/#{file.id}/edit"
      assert assigns(:authorization_vars).member?(:@site)
      assert assigns(:authorization_vars).member?(:@file)

      category = occams_cms_categories(:default)
      r :get, "/admin/sites/#{site.id}/categories/#{category.id}/edit"
      assert assigns(:authorization_vars).member?(:@site)
      assert assigns(:authorization_vars).member?(:@category)
    end
  end

  def test_public_authentication_default
    assert_equal "Occams::AccessControl::PublicAuthentication",
                 Occams.config.public_auth

    get "/"
    assert_response :success, response.body
  end

  def test_public_authorization_default
    assert_equal "Occams::AccessControl::PublicAuthorization",
                 Occams.config.public_authorization

    get "/"
    assert_response :success, response.body
  end

  def test_public_authentication_custom
    with_routing do |routes|
      routes.draw do
        get "(*cms_path)" => "access_control_test/test_authentication/content#show"
      end

      get "/"
      assert_response :unauthorized
      assert_equal "Test Login Denied", response.body
    end
  end

  def test_public_authorization_custom
    with_routing do |routes|
      routes.draw do
        get "(*cms_path)" => "access_control_test/test_authorization/content#show"
      end

      get "/"
      assert_response :forbidden
      assert_equal "Test Access Denied", response.body
    end
  end
end
