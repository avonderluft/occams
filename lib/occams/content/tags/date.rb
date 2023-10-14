# frozen_string_literal: true

# Tag for text content that is going to be rendered using text input with date widget
#   {{ cms:date identifier }}
#
class Occams::Content::Tags::Date < Occams::Content::Tags::Datetime
  def form_field(object_name, view, index)
    name    = "#{object_name}[fragments_attributes][#{index}][datetime]"
    options = { id: form_field_id, class: 'form-control', data: { 'cms-date' => true } }
    value   = content.present? ? content.to_s(:db) : ''
    input   = view.send(:text_field_tag, name, value, options)

    yield input
  end
end

Occams::Content::Renderer.register_tag(
  :date, Occams::Content::Tags::Date
)
