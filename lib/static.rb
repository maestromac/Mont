require 'byebug'

class Static
  attr_reader :app, :root
  def initialize(app)
    @app = app
    @root = root
  end

  def call(env)
    req = Rack::Request.new(env)
    path = req.path[1..-1]

    return app.call(env) unless can_serve?(path)

    mime_type = Rack::Mime.mime_type(File.extname(path))

    if File.file?(path)
      file = File.read(path)
      serve(200, file, mime_type)
    else
      serve(404, nil, mime_type)
    end

  end

  private

  def can_serve?(path)
    path.index("/#{root}")
  end

  def serve(status, file, mime_type)
    [404, { 'Content-Type' => "#{mime_type}" }, [file]]
  end
end
