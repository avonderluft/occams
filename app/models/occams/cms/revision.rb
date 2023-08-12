# frozen_string_literal: true

class Occams::Cms::Revision < ActiveRecord::Base
  self.table_name = 'occams_cms_revisions'

  serialize :data

  # -- Relationships --------------------------------------------------------
  belongs_to :record, polymorphic: true
end
