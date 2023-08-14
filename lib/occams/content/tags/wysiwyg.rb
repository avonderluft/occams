# frozen_string_literal: true

# Tag for text content that is going to be rendered using Redactor (default) in
# the admin area
#   {{ cms:wysiwyg identifier }}
#
#
class Occams::Content::Tag::Wysiwyg < Occams::Content::Tag::Fragment
  def form_field(object_name, view, index)
    name    = "#{object_name}[fragments_attributes][#{index}][content]"
    options = { id: form_field_id, data: { 'cms-rich-text' => true } }
    input   = view.send(:text_area_tag, name, content, options)
    yield input
  end
end

Occams::Content::Renderer.register_tag(
  :wysiwyg, Occams::Content::Tag::Wysiwyg
)
