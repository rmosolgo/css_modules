module CSSModules
  # Provides helpers to the view layer.
  # Add it to a controller with Rails' `helper` method.
  #
  # @example including ViewHelper in ApplicationController (and therefore all its descendants)
  #   class ApplicationController < ActionController::Base
  #     helper CSSModules::ViewHelper
  #   end
  module ViewHelper
    # @overload css_module(module_name, selector_name)
    #   Apply the styles from `module_name` for `selector_name`
    #
    #   @example Getting a selector within a module
    #      css_module("events_index", "header")
    #      # => "..." (opaque string which matches the stylesheet)
    #
    #   @param module_name
    #   @param selector_name DOM id or class name
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
    #   @param module_name
    #   @yieldparam [ModuleLookup] a helper for modulizing selectors within `module_name`
    #   @return [void]
    def css_module(module_name, selector_name = nil, &block)
      if selector_name.nil? && block_given?
        lookup = ModuleLookup.new(module_name)
        yield(lookup)
        nil
      elsif selector_name.present?
        CSSModules::Rewrite.modulize_selector(module_name.to_s, selector_name.to_s)
      else
        raise("css_module must be called with a module_name and either a selector_name or a block")
      end
    end

    # Shorthand for getting several classnames from one module
    class ModuleLookup
      def initialize(module_name)
        @module_name = module_name.to_s
      end

      def selector(selector_name)
        CSSModules::Rewrite.modulize_selector(@module_name, selector_name.to_s)
      end
    end
  end
end
