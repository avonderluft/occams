# frozen_string_literal: true

require_relative '../../../../test_helper'

class Occams::Admin::Cms::BaseControllerTest < ActionDispatch::IntegrationTest
  def test_get_jump
    r :get, occams_admin_cms_path
    assert_response :redirect
    assert_redirected_to occams_admin_cms_site_pages_path(occams_cms_sites(:default))
  end

  def test_get_jump_with_redirect_setting
    Occams.config.admin_route_redirect = '/cms-admin/sites'
    r :get, occams_admin_cms_path
    assert_response :redirect
    assert_redirected_to '/cms-admin/sites'
  end
end
