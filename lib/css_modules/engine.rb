module CSSModules
  class Engine < ::Rails::Engine
    isolate_namespace CSSModules

    initializer "css_modules.register_preprocessor" do |app|
      # Make CSSModules.js accessible to Sprockets
      app.config.assets.paths << File.expand_path("../assets", __FILE__)

      Sprockets.register_postprocessor('text/css', CSSModules::Processor.new)
    end
  end
end
