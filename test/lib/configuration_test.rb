# frozen_string_literal: true

require_relative '../test_helper'

class ConfigurationTest < ActiveSupport::TestCase
  def test_configuration_presence
    config = Occams::Configuration.new
    assert_equal 'Occams CMS Engine', config.cms_title
    assert_equal 'ApplicationController', config.admin_base_controller
    assert_equal 'ApplicationController', config.public_base_controller
    assert_equal 'Occams::AccessControl::AdminAuthentication',  config.admin_auth
    assert_equal 'Occams::AccessControl::AdminAuthorization',   config.admin_authorization
    assert_equal 'Occams::AccessControl::PublicAuthentication', config.public_auth
    assert_equal '', config.admin_route_redirect
    assert_equal false, config.enable_seeds
    assert_equal File.expand_path('db/cms_seeds', Rails.root), config.seeds_path
    assert_equal 25, config.revisions_limit
    %w[en es fr].each { |k| assert_includes config.locales.keys, k }
    assert_nil config.admin_locale
    assert_nil config.admin_cache_sweeper
    assert_equal false, config.allow_erb
    assert_nil config.allowed_helpers
    assert_nil config.allowed_partials
    assert_nil config.allowed_templates
    assert_nil config.hostname_aliases
    assert_equal ({ methods: [:content], except: [:content_cache] }), config.page_to_json_options
  end

  def test_initialization_overrides
    Occams.configuration.cms_title = 'New Title'
    assert_equal 'New Title', Occams.configuration.cms_title
  end
end
