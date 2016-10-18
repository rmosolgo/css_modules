# CSSModules

[![Build Status](https://travis-ci.org/rmosolgo/css_modules.svg?branch=master)](https://travis-ci.org/rmosolgo/css_modules)
[![Gem Version](https://badge.fury.io/rb/css_modules.svg)](https://badge.fury.io/rb/css_modules)

An alternative to "magic string" classnames in Sass or SCSS.

Thanks to [Fatih Kadir Akın](https://twitter.com/fkadev) for his post, ["How I Implemented CSS Modules in Ruby on Rails, Easily"](https://medium.com/@fkadev/how-i-implemented-css-modules-to-ruby-on-rails-easily-abb324ce22d), which led the way on this idea!

## Usage

### Add modules to stylesheets

Your `.sass` or `.scss` stylesheets can define modules with `:module(module_name)`:

```scss
:module(events) {
  .header {
    font-style: bold;
  }

  .link:visited {
    color: purple;
  }

  #footer {
    font-size: 0.8em;
  }
}
```

Sass requires an extra `\`:

```sass
\:module(events)
  .header
    font-style: bold
```

### Put modulized names into HTML

To access the contents of a module in a view, you must include the helpers in your controller:

```ruby
class EventsController < ApplicationController
  helper CSSModules::ViewHelper
end
```

(To use the view helper _everywhere_, include it in `ApplicationController`.)

Then, in your view, you can access the module & its contents by name:

```erb
<!-- access by module + identifier -->
<h1 id="<%= css_module("events", "main_header") %>">
  Events
</h1>

<!-- block helper -->
<% css_module("events") do |events_module| %>
  <div id="<%= events_module.selector("footer") %>">
    <%= link_to "Home", "/", class: events_module.selector("link") %>
    © My company
  </div>
<% end %>
```

#### Extra classes

You can also provide _multiple_, space-separated class names and/or extra class names to join without a module:

```ruby
# Apply "events" to "image-wrapper" and "image", then add "pull-left" without modification
css_module("events", "image-wrapper image", "pull-left")
#=> "events_123_image-wrapper events_123_image pull-left
```

#### Null module

If you pass `nil` as the module name, _no_ transformation is applied to the selectors.

```ruby
css_module(nil, "media-row")
# => "media-row"
css_module(nil) do |styles|
  styles.selector("image image--main", "pull-left")
  # => "image image--main pull-left"
end
```

### Use modulized names in JavaScript

In JavaScript, you can include a helper to access module styles:

```jsx
//= require css_module

// Module + identifier
var headerClass = CSSModule("events", "header")
$("." + headerClass).text() // => "Events"

// Or module helper function
var eventsModule = CSSModule("events")

function header() {
  var headerClass = eventsModule("header")
  return (
    <h1 className={headerClass}>Events</h1>
  )
}
```

#### Extra classes

You can also provide _multiple_, space-separated class names and/or extra class names to add without a module:

```js
// Apply "events" to "image-wrapper" and "image", then add "pull-left" without modification
CSSModule("events", "image-wrapper image", "pull-left")
// "events_123_image-wrapper events_123_image pull-left"
```

#### Null module

If you pass `null` as the module name, `CSSModule` will make _no_ transformation:

```js
CSSModule(null, "item")
// => "item"

var cssModule = CSSModule(null)
cssModule("item")
// => item
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'css_modules'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install css_modules
```

## TODO

- Dead code warning for Development env:
  - Warn when not all styles are used?
  - Sprockets require CSS to JS? `require_styles` ?
- Support plain `.css`
- Check for hash collisions in development
- Fix sprockets cache: a new version of this gem should expire an old cache

## License

[MIT](http://opensource.org/licenses/MIT).
