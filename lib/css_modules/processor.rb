module CSSModules
  # A Sprockets 3+ processor for transforming CSS files
  class Processor
    def call(input)
      rewritten_css = CSSModules::Rewrite.rewrite_css(input[:data])
      { data: rewritten_css }
    end
  end
end
