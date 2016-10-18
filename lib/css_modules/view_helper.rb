module CSSModules
  # Provides helpers to the view layer.
  # Add it to a controller with Rails' `helper` method.
  #
  # @example including ViewHelper in ApplicationController (and therefore all its descendants)
  #   class ApplicationController < ActionController::Base
  #     helper CSSModules::ViewHelper
  #   end
  module ViewHelper
    # @overload css_module(module_name)
    #   Apply the styles from `module_name` for `selector_name`
    #
    #   @example Passing a module to a partial
    #      style_module = css_module("events_index")
    #      render(partial: "header", locals: { style_module: style_module })
    #
    #   @param module_name [String]
    #   @return [StyleModule] helper for modulizing selectors within `module_name`
    #
    # @overload css_module(module_name, selector_names, bare_selector_names)
    #   Apply the styles from `module_name` for `selector_names`
    #
    #   @example Getting a selector within a module
    #      css_module("events_index", "header")
    #      # => "..." (opaque string which matches the stylesheet)
    #
    #   @param module_name [String]
    #   @param selector_names [String] Space-separated DOM ids or class names
    #   @param bare_selector_names [String] Space-separated selectors to be appended _without_ the module
    #   @return [String] modulized selector name for `class=` or `id=` in a view
    #
    # @overload css_module(module_name, &block)
    #   Modulize selectors within a block using the yielded helper.
    #
    #   @example modulizing a few selectors
    #     <% css_module("events_index") do |events_module| %>
    #       <h1 class="<%= events_module.selector("heading") %>">All events</h1>
    #       <p id="<%= events_module.selector("description") %>"> ... </p>
    #     <% end %>
    #
    #   @param module_name [String]
    #   @yieldparam [StyleModule] a helper for modulizing selectors within `module_name`
    #   @return [StyleModule] a helper for modulizing selectors within `module_name`
    def css_module(module_name, selector_names = nil, bare_selector_names = nil, &block)
      lookup = StyleModule.new(module_name)

      if selector_names.nil? && block_given?
        yield(lookup)
        lookup
      elsif selector_names.present?
        lookup.selector(selector_names.to_s, bare_selector_names.to_s)
      else
        lookup
      end
    end

    class StyleModule
      def initialize(module_name)
        @module_name = module_name
      end

      def name
        @module_name
      end

      # @see {ViewHelper#css_module}
      # @param selector_names [String]
      # @param bare_selector_names [String]
      def selector(selector_names, bare_selector_names = nil)
        create_joined_selector(@module_name, selector_names.to_s, bare_selector_names.to_s)
      end

      private

      def create_joined_selector(module_name, selector_names, bare_selector_names)
        padded_bare_selector_names = bare_selector_names.present? ? " #{bare_selector_names}" : ""
        case module_name
        when nil
          selector_names + padded_bare_selector_names
        else
          selector_names
            .split(" ")
            .map { |selector_name| CSSModules::Rewrite.modulize_selector(module_name, selector_name) }
            .join(" ")
            .concat(padded_bare_selector_names)
        end
      end
    end
  end
end
