require 'rack'
require_relative 'router'
require_relative 'exception_catcher'
require_relative 'static_assets'
require_relative '../app/controllers/controller_base'

router = Router.new
router.draw do
  #specify the routes for your application here.
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

middleware_stack = Rack::Builder.new do
  #place your middleware here.
  use ExceptionCatcher
  use StaticAssets
  run app
end.to_app

Rack::Server.start(
 app: middleware_stack,
 Port: 3000
)
