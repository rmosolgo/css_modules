module CSSModules
  # Provides helpers to the view layer.
  # Add it to a controller with Rails' `helper` method.
  #
  # @example including ViewHelper in ApplicationController (and therefore all its descendants)
  #   class ApplicationController < ActionController::Base
  #     helper CSSModules::ViewHelper
  #   end
  module ViewHelper
    # Apply the styles from `module_name` for `class_name`
    # @return [String] opaque classname for these styles
    def style_for(module_name, class_name)
      CSSModules::Rewrite.modulize_selector(module_name.to_s, class_name.to_s)
    end

    # Shorthand for getting several classnames from one module
    # @yield [ModuleLookup] a module-bound helper for classnames
    # @return [nil]
    def style_module(module_name)
      lookup = ModuleLookup.new(module_name)
      yield(lookup)
      nil
    end

    class ModuleLookup
      def initialize(module_name)
        @module_name = module_name.to_s
      end

      def style_for(class_name)
        CSSModules::Rewrite.modulize_selector(@module_name, class_name.to_s)
      end
    end
  end
end
