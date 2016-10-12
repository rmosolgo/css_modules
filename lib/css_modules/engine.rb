module CSSModules
  class Engine < ::Rails::Engine
    isolate_namespace CSSModules

    initializer "css_modules.register_preprocessor" do |app|
      # Make css_module.js accessible to Sprockets
      app.config.assets.paths << File.expand_path("../assets", __FILE__)

      # This is Sprockets 2 only :S
      app.config.assets.configure do |env|
        env.register_postprocessor('text/css', :css_modules) do |context, data|
          CSSModules::Rewrite.rewrite_css(data)
        end
      end
    end
  end
end
