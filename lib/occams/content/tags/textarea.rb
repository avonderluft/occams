# frozen_string_literal: true

# Tag for text content that is going to be rendered using textarea
#   {{ cms:textarea identifier }}
#
class Occams::Content::Tag::TextArea < Occams::Content::Tag::Fragment

  def form_field(object_name, view, index)
    name    = "#{object_name}[fragments_attributes][#{index}][content]"
    options = { id: form_field_id, data: { "cms-cm-mode" => "text/html" } }
    input   = view.send(:text_area_tag, name, content, options)

    yield input
  end

end

Occams::Content::Renderer.register_tag(
  :textarea, Occams::Content::Tag::TextArea
)
