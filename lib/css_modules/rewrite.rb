require "css_parser"
require "css_modules/transform"

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
    # @param module_name [String] A CSS module name
    # @param selector [String] A would-be DOM selector (without the leading `.` or `#`)
    # @return [String] An opaque selector for this module-selector pair
    def modulize_selector(module_name, selector)
      tran = Rails.env.production? ? Transform::ProductionTransform : Transform::DevelopmentTransform
      tran.transform(module_name, selector)
    end

    private
    module_function

    # This parses the selector for `:module` definitions or does nothing.
    def parse_selector(selector)
      matches = RE_MODULE.match(selector)
      if matches.nil?
        selector
      else
        module_name = matches[:module_name]
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
        "##{modulize_selector(module_ident, selector[1..-1])}"
      when "."
        ".#{modulize_selector(module_ident, selector[1..-1])}"
      else
        selector
      end
    end
  end
end
