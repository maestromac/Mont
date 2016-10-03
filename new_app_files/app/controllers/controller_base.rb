require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, params = {} )
    @req, @res, @params = req, res, params.merge(req.params)
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    unless already_built_response?

      res['location'] = url
      res.status = 302
      session.store_session(res)
      @already_built_response = true
    else
      raise "Error!"
    end
  end

  def render_content(content, content_type)
    unless already_built_response?
      res['content-type'] = content_type
      res.body = [content]
      session.store_session(res)
      @already_built_response = true
    else
      raise "Error!"
    end
  end

  def render(template_name)
    controller_name = self.class.to_s
    path = "views/#{controller_name.underscore}/#{template_name}.html.erb"
    contents = File.read(path)
    erb = ERB.new(contents).result(binding)
    render_content( erb , 'text/html')
  end

  def session
    @session ||= Session.new(req)
  end

  def invoke_action(name)
    unless @req.request_method == 'GET'

      if protect_from_forgery?
        check_authenticity_token
      else
        form_authenticity_token
      end

    end

    self.send(name)
    render(name) unless already_built_response?
  end

  def form_authenticity_token
    @token ||= generate_authenticity_token
    res.set_cookie('authenticity_token', @token)
    @token
  end

  def check_authenticity_token
    c = req.cookies['authenticity_token']

    unless c && c == params['authenticity_token']
      raise 'Invalid authenticity token'
    end
  end

  def self.protect_from_forgery
    @@protect_from_forgery = true
  end

  def protect_from_forgery?
    @@protect_from_forgery
  end

  def generate_authenticity_token
    SecureRandom.urlsafe_base64(16)
  end

end
