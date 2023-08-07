# frozen_string_literal: true

class Occams::Cms::BaseController < Occams.config.public_base_controller.to_s.constantize
  before_action :load_cms_site

  helper Occams::CmsHelper

protected

  def load_cms_site
    @cms_site ||=
      if params[:site_id]
        ::Occams::Cms::Site.find_by_id(params[:site_id])
      else
        ::Occams::Cms::Site.find_site(request.host_with_port.downcase, request.fullpath)
      end

    if @cms_site
      if @cms_site.path.present? && !params[:site_id]
        if params[:cms_path]&.match(%r{\A#{@cms_site.path}})
          params[:cms_path].gsub!(%r{\A#{@cms_site.path}}, "")
          params[:cms_path]&.gsub!(%r{\A/}, "")
        else
          raise ActionController::RoutingError, "Site Not Found"
        end
      end
    else
      raise ActionController::RoutingError, "Site Not Found"
    end
  end
end
