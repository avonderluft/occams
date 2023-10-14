# frozen_string_literal: true

require_relative '../../../test_helper'

class ContentTagsHelperTest < ActiveSupport::TestCase
  def test_init
    tag = Occams::Content::Tags::Helper.new(context: @page, params: ['helper_method'])
    assert_equal 'helper_method', tag.method_name
    assert_equal [], tag.params
  end

  def test_init_with_params
    tag = Occams::Content::Tags::Helper.new(
      context: @page,
      params: ['helper_method', 'param', { 'key' => 'val' }]
    )
    assert_equal 'helper_method', tag.method_name
    assert_equal ['param', { 'key' => 'val' }], tag.params
  end

  def test_init_without_method_name
    message = 'Missing method name for helper tag'
    assert_raises Occams::Content::Tag::Error, message do
      Occams::Content::Tags::Helper.new(context: @page)
    end
  end

  def test_content
    tag = Occams::Content::Tags::Helper.new(
      context: @page,
      params: ['method_name', 'param', { 'key' => 'val' }]
    )
    assert_equal '<%= method_name("param",{"key"=>"val"}) %>', tag.content
  end

  def test_render
    tag = Occams::Content::Tags::Helper.new(
      context: @page,
      params: ['method_name', 'param', { 'key' => 'val' }]
    )
    assert_equal '<%= method_name("param",{"key"=>"val"}) %>', tag.render
  end

  def test_render_with_whitelist
    Occams.config.allowed_helpers = %i[tester eval]
    tag = Occams::Content::Tags::Helper.new(context: @page, params: ['tester'])
    assert_equal '<%= tester() %>', tag.render

    tag = Occams::Content::Tags::Helper.new(context: @page, params: ['eval'])
    assert_equal '<%= eval() %>', tag.render

    tag = Occams::Content::Tags::Helper.new(context: @page, params: ['not_whitelisted'])
    assert_nil tag.render
  end

  def test_render_with_blacklist
    Occams::Content::Tags::Helper::BLACKLIST.each do |method|
      tag = Occams::Content::Tags::Helper.new(context: @page, params: [method])
      assert_nil tag.render
    end
  end

  def test_render_with_erb_injection
    tag = Occams::Content::Tags::Helper.new(
      context: @page,
      params: ["foo\#{:bar}", "foo\#{Kernel.exec('poweroff')"]
    )
    assert_equal "<%= foo\#{:bar}(\"foo\\\#{Kernel.exec('poweroff')\") %>", tag.render
  end
end
