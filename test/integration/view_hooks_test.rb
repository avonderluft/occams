# frozen_string_literal: true

require_relative "../test_helper"

class ViewHooksIntegrationTest < ActionDispatch::IntegrationTest
  def teardown
    Occams::ViewHooks.remove(:navigation)
  end

  def test_hooks_rendering
    Occams::Admin::Cms::SitesController.append_view_path(File.expand_path("../fixtures/views", File.dirname(__FILE__)))
    Occams::ViewHooks.add(:navigation, "/nav_hook")

    r :get, occams_admin_cms_sites_path
    assert_response :success
    assert_match %r{hook_content}, response.body
  end

  def test_hooks_rendering_with_multiples
    Occams::Admin::Cms::SitesController.append_view_path(File.expand_path("../fixtures/views", File.dirname(__FILE__)))
    Occams::ViewHooks.add(:navigation, "/nav_hook")
    Occams::ViewHooks.add(:navigation, "/nav_hook_2")

    r :get, occams_admin_cms_sites_path
    assert_response :success
    assert_match %r{hook_content}, response.body
    assert_match %r{<hook_content_2>}, response.body
  end

  def test_hooks_rendering_with_proper_order
    Occams::Admin::Cms::SitesController.append_view_path(File.expand_path("../fixtures/views", File.dirname(__FILE__)))
    Occams::ViewHooks.add(:navigation, "/nav_hook_2", 0)
    Occams::ViewHooks.add(:navigation, "/nav_hook", 1)

    r :get, occams_admin_cms_sites_path
    assert_response :success
    assert_match %r{<hook_content_2>hook_content}, response.body
  end

  def test_hooks_rendering_with_no_hook
    Occams::ViewHooks.remove(:navigation)

    r :get, occams_admin_cms_sites_path
    assert_response :success
    assert_no_match %r{hook_content}, response.body
  end
end
