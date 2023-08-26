# frozen_string_literal: true

# Nav Tag for rendering previous and next sibling links relative to current page
#   {{ cms:siblings }}
#   {{ cms:siblings style: "font-style: italic", exclude: "404-page, search-page" }}
# To customize your siblings style, add a 'siblings' id to your CSS, e.g
# #siblings {
#   color: #006633;
#   font-family: Verdana, Arial, Helvetica, sans-serif;
#   font-size: 95%;
#   margin-top: 12px;
#   margin-bottom: 4px;
#   font-style: italic;
# }
# and/or pass in style overrides with the 'style' parameter (see above)
#
# To exclude siblings, list their slugs with the 'exclude' parameter
# as comma-delimited string, e.g. as above - exclude: "404-page, search-page"
#
# style and exclude parameters are optional

class Occams::Content::Tag::Siblings < Occams::Content::Tag
  attr_reader :path, :locals

  def initialize(context:, params: [], source: nil)
    super
    options = params.extract_options!
    @style = ''
    @style = "<style>#siblings {#{options['style']}}</style>" if options['style']
    @exclude = []
    @exclude = options['exclude'].split(',') if options['exclude']
    @links = '<div id="siblings">'

    prevp = false
    sibs = context.self_and_siblings.sort_by(&:position)
    page_idx = sibs.index(context)
    sibs.each do |sib|
      sib_idx = sibs.index(sib)
      next if sibs.index(sib) == page_idx
      next if @exclude.include? sib.slug
      next if Rails.env == 'production' && !sib.is_published

      if sib_idx == page_idx - 1
        @links += "<a href=#{sib.url(relative: true)}>#{sib.label}</a> &laquo;&nbsp;<em>Previous</em> &bull; "
        prevp = true
      elsif sib_idx == page_idx + 1
        @links += '&bull;' unless prevp
        @links += "<em>Next</em>&nbsp;&raquo; <a href=#{sib.url(relative: true)}>#{sib.label}</a>"
      end
    end
    @links += '</div>'
  end

  def content
    format("#{@style}#{@links}")
  end
end

Occams::Content::Renderer.register_tag(
  :siblings, Occams::Content::Tag::Siblings
)
