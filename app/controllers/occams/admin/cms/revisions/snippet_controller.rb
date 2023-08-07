# frozen_string_literal: true

class Occams::Admin::Cms::Revisions::SnippetController < Occams::Admin::Cms::Revisions::BaseController
private

  def load_record
    @record = @site.snippets.find(params[:snippet_id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = I18n.t("occams.admin.cms.revisions.record_not_found")
    redirect_to occams_admin_cms_site_snippets_path(@site)
  end

  def record_path
    edit_occams_admin_cms_site_snippet_path(@site, @record)
  end
end
