require "css_modules/transform"
require "sass"

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
      # Parse incoming CSS into an AST
      css_root = Sass::SCSS::CssParser.new(css_module_code, "(CSSModules)", 1).parse

      Sass::Tree::Visitors::SetOptions.visit(css_root, {})
      ModuleVisitor.visit(css_root)

      css_root.render
    end

    # Combine `module_name` and `selector`, but don't prepend a `.` or `#`
    # because this value will be inserted into the HTML page as `class=` or `id=`
    # @param module_name [String] A CSS module name
    # @param selector [String] A would-be DOM selector (without the leading `.` or `#`)
    # @return [String] An opaque selector for this module-selector pair
    def modulize_selector(module_name, selector)
      tran = CSSModules.env == :production ? Transform::ProductionTransform : Transform::DevelopmentTransform
      tran.transform(module_name, selector)
    end

    class ModuleVisitor < Sass::Tree::Visitors::Base
      # No need to `yield` here since we run _after_ Sass -- it's already flattened.
      # @return [void]
      def visit_rule(node)
        node.rule = node.rule.map { |r| transform_selector(r) }
        node.parsed_rules = rebuild_parsed_rules(node.parsed_rules)
      end

      private

      def rebuild_parsed_rules(parsed_rules)
        new_members = parsed_rules.members.map do |member_seq|
          # `member_seq` is actually a deeply-nested array-like thing
          # but since we're running _after_ Sass itself,
          # we know all the tricky stuff is already taken care of.
          # So now we can flatten it and re-parse it, no problem.
          rule_s = member_seq.to_s
          transformed_rule_s = transform_selector(rule_s)
          selector_to_sass(transformed_rule_s)
        end
        Sass::Selector::CommaSequence.new(new_members)
      end

      def selector_to_sass(selector)
        # This strips off leading whitespace, should I be putting it back on?
        Sass::SCSS::StaticParser.new(selector.strip, nil, 1).parse_selector
      end

      # This parses the selector for `:module` definitions or does nothing.
      def transform_selector(selector)
        matches = Rewrite::RE_MODULE.match(selector)
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
      def rebuild_selector(module_name, selector)
        case selector[0]
        when "#"
          "##{Rewrite.modulize_selector(module_name, selector[1..-1])}"
        when "."
          ".#{Rewrite.modulize_selector(module_name, selector[1..-1])}"
        else
          selector
        end
      end
    end
  end
end
