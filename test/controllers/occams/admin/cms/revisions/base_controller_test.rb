# frozen_string_literal: true

require_relative '../../../../../test_helper'

class Occams::Admin::Cms::Revisions::BaseControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rev_bc = Occams::Admin::Cms::Revisions::BaseController.new
  end

  def test_unimplemented_methods
    %i[load_record record_path].each do |m|
      assert_raises RuntimeError, 'not implemented' do
        @rev_bc.send(m)
      end
    end
  end
end
