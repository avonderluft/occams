# frozen_string_literal: true

class Occams::Admin::Cms::Revisions::TranslationController < Occams::Admin::Cms::Revisions::BaseController

  def show
    @current_content = @record.fragments.each_with_object({}) do |b, c|
      c[b.identifier] = b.content
    end
    @versioned_content = @record.fragments.each_with_object({}) do |b, c|
      d = @revision.data["fragments_attributes"].detect { |r| r[:identifier] == b.identifier }
      c[b.identifier] = d.try(:[], :content)
    end

    render "occams/admin/cms/revisions/show"
  end

private

  def load_record
    @page   = @site.pages.find(params[:page_id])
    @record = @page.translations.find(params[:translation_id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = I18n.t("occams.admin.cms.revisions.record_not_found")
    redirect_to occams_admin_cms_site_pages_path(@site)
  end

  def record_path
    edit_occams_admin_cms_site_page_translation_path(@site, @page, @record)
  end

end
