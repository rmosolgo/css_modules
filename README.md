# CSSModules

An alternative to "magic string" classnames in CSS.

Thanks to [Fatih Kadir Akın](https://twitter.com/fkadev) for his post, ["How I Implemented CSS Modules in Ruby on Rails, Easily"](https://medium.com/@fkadev/how-i-implemented-css-modules-to-ruby-on-rails-easily-abb324ce22d), which led the way on this idea!

## Usage

Your stylesheets can define modules with `:module(module_name)`:

```css
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
<h1 id="<%= style_for(:events, :main_header) %>">
  Events
</h1>

<!-- block helper -->
<% style_module(:events) do |styles| %>
  <div id="<%= styles.style_for(:footer) %>">
    <%= link_to "Home", "/", class: styles.style_for(:link) %>
    © My company
  </div>
<% end %>
```

In JavaScript, you can include a helper to access module styles:

```jsx
//= require CSSModules

// Module + identifier
var headerClass = CSSModules.styleFor("events", "header")
$("." + headerClass).text() // => "Events"

// Or module helper function
var eventsStyles = CSSModules.module("events")

function header() {
  var headerClass = eventStyles("header")
  return (
    <h1 className={headerClass}>Events</h1>
  )
}
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

- Create a mechanism for opting in (converting all stylesheets is bad)
- Use folders as nested modules?
- Support minified identifiers for Production Env
- Dead code warning for Development env:
  - Warn when not all styles are used?
  - Sprockets require CSS to JS? `require_styles` ?

## License

[MIT](http://opensource.org/licenses/MIT).
