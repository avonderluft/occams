# frozen_string_literal: true

class ActionDispatch::Routing::Mapper
  def occams_route_cms(options = {})
    Occams.configuration.public_cms_path = options[:path]

    scope module: :occams, as: :occams do
      namespace :cms, path: options[:path] do
        get 'cms-css/:site_id/:identifier(/:cache_buster)' => 'assets#render_css', as: 'render_css'
        get 'cms-js/:site_id/:identifier(/:cache_buster)'  => 'assets#render_js',  as: 'render_js'

        get '(*cms_path)' => 'content#show', as: 'render_page', action: '/:format'
      end
    end
  end
end
