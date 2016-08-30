# Mont

A lightweight Ruby MVC framework inspired by Rails.

## Featuring

### CSRF protection

```Ruby
require_relative '../models/cat'

class DogesController < ControllerBase

  def create
    verify_authenticity_token
    @Doge = Doge.new(name: params["name"], wow_id: params["wow_id"])
    @Doge.save

    render :show
  end

end
```
Simply include  ```verify_authenticity_token``` to ensures no none 'GET' action can be done without authenticity token being checked

### Session

```Ruby
session['sample_key'] = 'sample_text!'
```
Persist states by storing cookies in session

### Flash

```Ruby
flash[:error] = 'Invalid credentials!'
```
or
```Ruby
flash.now[:error] = 'Invalid credentials'
```

Whether you want to alert the user for just this session or the next, Flash will be written into the cookies and will get cleared with each request.

### Static Assets

```
app
└─── public
      ├── doge
      |    └── much-wow.jpg
      └── summer
            └── june
                ├── sandle.png
                └── italian-ice.jpg
```
Including contents in your app/public and it will automatically be served as a static assets.


## Installation

1. Fork or clone this repo.
2. run ```bundle install```
3. make a controller

  ```
  # app/controllers/doges_controller.rb

  require_relative 'lib/controller_base'
  require_relative '../models/doge'

  class DogesController < ControllerBase
    def index
      @doges = Doge.all

      render :index
    end
  end
  ```
4. construct a route

  ```
  # config/routes.rb

  ROUTER.draw do
    get Regexp.new("^/doges$"), DogesController, :index
    get Regexp.new("^/doges/new$"), DogesController, :new
    post Regexp.new("^/doges$"), DogesController, :create
  end
  ```
5. start the server with ```bundle exec rackup config/server.rb```
