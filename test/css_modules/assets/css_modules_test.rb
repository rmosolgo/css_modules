require "test_helper"

class CSSModulesJSTest < Minitest::Test
  def execjs_context
    @execjs_context ||= begin
      css_modules_js = Rails.application.assets["css_modules.js"].to_s
      # polyfill required for execjs
      base_64_js = Rails.application.assets["base64.js"].to_s
      ExecJS.compile(css_modules_js + base_64_js)
    end
  end

  def test_it_matches_ruby_to_js
    js_name = execjs_context.eval("CSSModules.styleFor('items', 'list-item')")
    ruby_name = CSSModules::Rewrite.modulize_selector("items", "list-item")
    assert_equal("aXRlbXM_items_list-item", js_name)
    assert_equal("aXRlbXM_items_list-item", ruby_name)
  end

  def test_the_module_function_matches_ruby
    js_name = execjs_context.eval("CSSModules.module('items')('list-item')")
    ruby_name = CSSModules::Rewrite.modulize_selector("items", "list-item")
    assert_equal("aXRlbXM_items_list-item", js_name)
    assert_equal("aXRlbXM_items_list-item", ruby_name)
  end
end
