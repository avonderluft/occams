# frozen_string_literal: true

require_relative "../test_helper"

class LayoutsFrontendTest < ApplicationSystemTestCase

  setup do
    @site = occams_cms_sites(:default)
  end

  def test_new_identifier
    visit_p new_occams_admin_cms_site_layout_path(@site)
    fill_in "Layout Name", with: "Test Layout"
    assert_equal "test-layout", find_field("Identifier").value
  end

end
