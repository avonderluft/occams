# frozen_string_literal: true

require_relative "routes/cms_admin"
require_relative "routes/cms"

class ActionDispatch::Routing::Mapper
  def occams_route(identifier, options = {})
    send("occams_route_#{identifier}", **options)
  end
end
