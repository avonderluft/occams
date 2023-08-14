# frozen_string_literal: true

class Occams::Admin::Cms::Revisions::LayoutController < Occams::Admin::Cms::Revisions::BaseController
private

  def load_record
    @record = @site.layouts.find(params[:layout_id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = I18n.t('occams.admin.cms.revisions.record_not_found')
    redirect_to occams_admin_cms_site_layouts_path(@site)
  end

  def record_path
    edit_occams_admin_cms_site_layout_path(@site, @record)
  end
end
