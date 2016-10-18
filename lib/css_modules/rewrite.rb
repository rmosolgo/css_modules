require "css_modules/transform"
require "sass"

module CSSModules
  module Rewrite
    # Module Scopes
    # :module(login) { .button {color: red;} }
    RE_MODULE = /^\:module\((?<module_name>.*?)\)/

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
        node.parsed_rules = rebuild_parsed_rules(node.parsed_rules)
      end

      private

      def rebuild_parsed_rules(parsed_rules)
        new_members = parsed_rules.members.map do |member_seq|
          leading_rule = first_pseudo_selector(member_seq).to_s
          matches = leading_rule && Rewrite::RE_MODULE.match(leading_rule)
          if matches
            module_name = matches[:module_name]
            deeply_transform(module_name, member_seq)
          else
            member_seq
          end
        end
        Sass::Selector::CommaSequence.new(new_members)
      end

      # Get the first Sass::Selector::Pseudo member of `seq`, or nil
      def first_pseudo_selector(seq)
        case seq
        when Sass::Selector::AbstractSequence
          seq.members.find { |m| first_pseudo_selector(m) }
        when Sass::Selector::Pseudo
          seq
        else # eg, String
          nil
        end
      end

      # We know this is a modulized rule
      # now we should transform its ID and classes to modulized
      def deeply_transform(module_name, seq)
        case seq
        when Sass::Selector::AbstractSequence
          new_members = seq.members.map { |m| deeply_transform(module_name, m) }
          new_members.compact! # maybe a module selector returned nil
          clone_sequence(seq, new_members)
        when Sass::Selector::Id, Sass::Selector::Class
          # Sass 3.2 has an array here, Sass 3.4 has a string:
          selector_name = seq.name.is_a?(Array) ? seq.name.first : seq.name
          modulized_name = Rewrite.modulize_selector(module_name, selector_name)
          seq.class.new(modulized_name)
        when Sass::Selector::Pseudo
          if seq.to_s =~ /:module/
            nil
          else
            seq
          end
        else
          seq
        end
      end

      # Make a new kind of `seq`, containing `new_members`
      def clone_sequence(seq, new_members)
        case seq
        when Sass::Selector::Sequence
          seq.class.new(new_members)
        when Sass::Selector::CommaSequence
          seq.class.new(new_members)
        when Sass::Selector::SimpleSequence
          seq.class.new(new_members, seq.subject?)
        else
          raise("Unknown sequence to clone: #{seq.class}")
        end
      end

      # Debug print-out of a sequence:
      def deep_print(seq, indent = "")
        case seq
        when Sass::Selector::AbstractSequence
          puts indent + seq.class.name + " => "
          seq.members.map { |m| deep_print(m, indent + "  ") }
        else
          puts indent + seq.class.name + " (#{seq})"
        end
      end
    end
  end
end
