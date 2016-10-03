class StaticAssets
  attr_reader :app
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    match_data = /(\/public\/.+)/.match(req.path)
    if match_data
      res = Rack::Response.new
      res.write(File.read("../app/#{match_data[1]}"))
      res.finish
    else
      app.call(env)
    end
  end
end
