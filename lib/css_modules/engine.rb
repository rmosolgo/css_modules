module CSSModules
  class Engine < ::Rails::Engine
    isolate_namespace CSSModules

    initializer "css_modules.register_preprocessor" do |app|
      # Make css_module.js accessible to Sprockets
      app.config.assets.paths << File.expand_path("../assets", __FILE__)

      app.config.assets.configure do |env|
        env.register_postprocessor('text/css', RewritePostprocessor)
      end
    end

    # Sprockets 2 & Sprockets 3-compatible postprocessor
    # https://github.com/rails/sprockets/blob/master/guides/extending_sprockets.md#supporting-all-versions-of-sprockets-in-processors
    class RewritePostprocessor
      # Sprockets 2
      def initialize(filename)
        @source = yield
      end

      def render(variable, empty_hash)
        self.class.call(data: @source)
      end

      # Sprockets 3+
      def self.call(input)
        CSSModules::Rewrite.rewrite_css(input[:data])
      end
    end
  end
end
