# frozen_string_literal: true

# We can't have this in config/routes.rb as they will get pulled in into parent
# application automatically. We want user to manually place them.
Occams::Application.routes.draw do
  occams_route :cms_admin
  occams_route :cms
end
