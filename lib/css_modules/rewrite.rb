require "css_parser"
require "base64"

module CSSModules
  module Rewrite
    # Module Scopes
    # :module(login) { .button {color: red;} }
    RE_MODULE = /^\:module\((?<module_name>.*?)\)\s+(?<declarations>.*)/

    module_function
    # Take css module code as input, and rewrite it as
    # browser-friendly CSS code. Apply opaque transformations
    # so that selectors can only be accessed programatically,
    # not by class name literals.
    def rewrite_css(css_module_code)
      parser = CssParser::Parser.new
      parser.load_string!(css_module_code)

      rules = ""

      parser.each_selector do |selector, declarations, specificity|
        prettified_declarations = declarations.gsub(/;\s+/, ";\n  ")
        modulized_selector = parse_selector(selector)
        rules << "#{modulized_selector} {\n  #{prettified_declarations}\n}\n"
      end

      rules.strip!
      rules
    end

    # Combine `module_name` and `selector`, but don't prepend a `.` or `#`
    # because this value will be inserted into the HTML page as `class=` or `id=`
    def modulize_selector(module_name, selector)
      transformed_name = transform_name(module_name)
      "#{transformed_name}_#{selector}"
    end

    private
    module_function

    # This parses the selector for `:module` definitions or does nothing.
    def parse_selector(selector)
      matches = RE_MODULE.match(selector)
      if matches.nil?
        selector
      else
        module_name = transform_name(matches[:module_name])
        declaration_parts = matches[:declarations].split(" ")
        declaration_parts
          .map { |declaration_or_operator| rebuild_selector(module_name, declaration_or_operator) }
          .join(" ")
      end
    end

    # If `selector` is a class or ID, scope it to this module.
    # If it is a bare element, leave it unscoped.
    def rebuild_selector(module_ident, selector)
      case selector[0]
      when "#"
        "##{module_ident}_#{selector[1..-1]}"
      when "."
        ".#{module_ident}_#{selector[1..-1]}"
      else
        selector
      end
    end

    def transform_name(css_module_name)
      # Some base64 characters aren't valid for CSS (eg, `=`)
      opaque_string = Base64.encode64(css_module_name).gsub(/[^a-zA-Z0-9]/, "")
      # p [css_module_name, opaque_string]
      "#{opaque_string}_#{css_module_name}"
    end
  end
end
