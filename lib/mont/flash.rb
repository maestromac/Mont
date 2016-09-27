require 'json'

class Flash
  attr_reader :now

  def initialize(req)
    c = req.cookies['_rails_lite_app_flash']
    c_content = c ? JSON.parse(c) : {}
    @flash = FlashStore.new
    @now = FlashStore.new(c_content)
  end

  def [](key)
    @flash[key] || @now[key]
  end

  def []=(key, value)
    @flash[key] = value
    @now[key] = value
  end

  def store_flash(res)
    res.set_cookie('_rails_lite_app_flash', {path: '/', value: @flash.to_json})
  end

end

class FlashStore
  def initialize(store={})
    @store = store
  end

  def [](key)
    @store[key]
  end

  def []=(key, value)
    @store[key] = value
  end

  def to_json
    @store.to_json
  end

end
