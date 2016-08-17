# Mont

A lightweight Ruby MVC framework inspired by Rails.

## Featuring

### CSRF protection

```Ruby
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
```
Ensures no none 'GET' action can be done without authenticity token being checked

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

Fork this repo!
