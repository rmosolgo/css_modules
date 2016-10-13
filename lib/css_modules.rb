require "css_modules/engine"
require "css_modules/version"
require "css_modules/rewrite"
require "css_modules/view_helper"


module CSSModules
  class << self
    attr_accessor :env
  end
  # If `:production`, then we use shorter hashes
  self.env = Rails.env.production? ? :production : :development
end
