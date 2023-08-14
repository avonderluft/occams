# frozen_string_literal: true

# Tag for reusable snippets within context's site scope. Looks like this:
#   {{cms:snippet identifier}}
# Snippets may have more tags in them like fragments, so they may be expanded too.
#
class Occams::Content::Tag::Snippet < Occams::Content::Tag
  attr_reader :identifier

  def initialize(context:, params: [], source: nil)
    super
    @identifier = params[0]

    return if @identifier.present?

    raise Error, 'Missing identifier for snippet tag'
  end

  def content
    if snippet.markdown
      Kramdown::Document.new(snippet.content.to_s).to_html
    else
      snippet.content
    end
  end

  # Grabbing or initializing Occams::Cms::Snippet object
  def snippet
    context.site.snippets.detect { |s| s.identifier == identifier } ||
      context.site.snippets.build(identifier: identifier)
  end
end

Occams::Content::Renderer.register_tag(
  :snippet, Occams::Content::Tag::Snippet
)
