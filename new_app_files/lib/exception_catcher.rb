class ExceptionCatcher
  attr_reader :app
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      app.call(env)

    rescue Exception => e
      @backtrace = e.backtrace
      @message = e.message
      @preview = get_code_preview(@backtrace.first)

      @res = Rack::Response.new
      render_errors
      @res.finish
    end
  end

  private
  def get_code_preview(code_backtrace)
    match_data = /(.+\.rb):(\d+)/.match(code_backtrace)
    file_path = match_data[1]
    line_number = match_data[2].to_i
    IO.readlines("#{file_path}")[line_number - 1]
  end

  def render_errors
    path = "../app/views/errors.html.erb"
    erb_file = File.read(path)
    template = ERB.new(erb_file)

    @res['Content-Type'] = 'text/html'
    @res.write(template.result(binding))
  end
end
