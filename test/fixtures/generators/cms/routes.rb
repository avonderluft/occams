Test::Application.routes.draw do
  occams_route :cms_admin, path: "/admin"
  # Ensure that this route is defined last
  occams_route :cms, path: "/"
end
