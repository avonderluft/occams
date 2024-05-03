# frozen_string_literal: true

module Occams::ReorderAction
  extend ActiveSupport::Concern

  included do
    mattr_accessor :reorder_action_resource
  end

  def reorder
    resource_class = self.class.reorder_action_resource
    (params.permit(order: [])[:order] || []).each_with_index do |id, index|
      resource_class.where(id: id).update_all(position: index)
    end
    if resource_class == ::Occams::Cms::Page
      Occams::Cms::Page.all.each(&:save!)
    end
    head :ok
  end
end
