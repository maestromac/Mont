require 'json'

class Session

  def initialize(req)
    c = req.cookies['_mont_app']
    @cookies = c ? JSON.parse(c) : {}
  end

  def [](key)
    @cookies[key]
  end

  def []=(key, val)
    @cookies[key] = val
  end

  def store_session(res)
    res.set_cookie('_mont_app', {path: '/', value: @cookies.to_json})
  end
end
