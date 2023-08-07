# frozen_string_literal: true

class Occams::Admin::Cms::BaseController < Occams::Admin::BaseController
  before_action :load_admin_site,
                :set_locale,
                :load_seeds,
                except: :jump

  layout :infer_layout

  if Occams.config.admin_cache_sweeper.present?
    cache_sweeper(*Occams.config.admin_cache_sweeper)
  end

  def jump
    path = Occams.config.admin_route_redirect
    return redirect_to(path) unless path.blank?

    load_admin_site
    redirect_to occams_admin_cms_site_pages_path(@site) if @site
  end

protected

  def load_admin_site
    id_param = params[:site_id] || session[:site_id]
    if (@site = ::Occams::Cms::Site.find_by(id: id_param) || ::Occams::Cms::Site.first)
      session[:site_id] = @site.id
    else
      I18n.locale = Occams.config.admin_locale || I18n.default_locale
      flash[:danger] = I18n.t("occams.admin.cms.base.site_not_found")
      redirect_to(new_occams_admin_cms_site_path)
    end
  end

  def set_locale
    I18n.locale = Occams.config.admin_locale || @site&.locale
    true
  end

  def load_seeds
    return unless Occams.config.enable_seeds

    controllers = %w[layouts pages snippets files].collect { |c| "occams/admin/cms/" + c }
    if controllers.member?(params[:controller]) && params[:action] == "index"
      Occams::Seeds::Importer.new(@site.identifier).import!
      flash.now[:warning] = I18n.t("occams.admin.cms.base.seeds_enabled")
    end
  end

  def infer_layout
    false if params[:layout] == "false"
  end
end
