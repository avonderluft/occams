# frozen_string_literal: true

# Tag for injecting template rendering. Example tag:
#   {{cms:template template/path}}
# This expands into something like this:
#   <%= render template: "template/path" %>
# Whitelist is can be used to control what templates are available.
#
class Occams::Content::Tags::Template < Occams::Content::Tag
  attr_reader :path

  def initialize(context:, params: [], source: nil)
    super
    @path = params[0]

    return if @path.present?

    raise Error, 'Missing template path for template tag'
  end

  # we output erb into rest of the content
  def allow_erb?
    true
  end

  def content
    format('<%%= render template: %<path>p %%>', path: path)
  end

  def render
    whitelist = Occams.config.allowed_templates
    if whitelist.is_a?(Array)
      whitelist.member?(@path) ? content : ''
    else
      content
    end
  end
end

Occams::Content::Renderer.register_tag(
  :template, Occams::Content::Tags::Template
)
