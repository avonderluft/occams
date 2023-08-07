# frozen_string_literal: true

class Occams::Admin::BaseController < Occams.config.admin_base_controller.to_s.constantize
  include Occams::Paginate

  # Authentication module must have `authenticate` method
  include Occams.config.admin_auth.to_s.constantize

  # Authorization module must have `authorize` method
  include Occams.config.admin_authorization.to_s.constantize

  helper Occams::Admin::CmsHelper
  helper Occams::CmsHelper

  protect_from_forgery with: :exception

  before_action :authenticate

  layout "occams/admin/cms"
end
