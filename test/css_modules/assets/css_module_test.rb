require "test_helper"

class CSSModulesJSTest < Minitest::Test
  ITEMS_LIST_ITEM = "items_4719_list-item"
  ITEMS_LIST_ITEM_PRODUCTION = "i4719l"
  def execjs_context
    @execjs_context ||= begin
      css_modules_js = Rails.application.assets["css_module.js"].to_s
      # polyfill required for execjs
      base_64_js = Rails.application.assets["base64.js"].to_s
      ExecJS.compile(css_modules_js + base_64_js)
    end
  end

  def test_it_matches_ruby_to_js
    js_name = execjs_context.eval("CSSModule('items', 'list-item')")
    ruby_name = CSSModules::Rewrite.modulize_selector("items", "list-item")
    assert_equal(ITEMS_LIST_ITEM, ruby_name)
    assert_equal(ITEMS_LIST_ITEM, js_name)
  end

  def test_the_module_function_matches_ruby
    js_name = execjs_context.eval("CSSModule('items')('list-item')")
    ruby_name = CSSModules::Rewrite.modulize_selector("items", "list-item")
    assert_equal(ITEMS_LIST_ITEM, ruby_name)
    assert_equal(ITEMS_LIST_ITEM, js_name)
  end

  def test_it_matches_production
    js_name = execjs_context.eval("CSSModule('items', 'list-item', 'production')")
    ruby_name = CSSModules::Transform::ProductionTransform.transform("items", "list-item")
    assert_equal(ITEMS_LIST_ITEM_PRODUCTION, ruby_name)
    assert_equal(ITEMS_LIST_ITEM_PRODUCTION, js_name)
  end
end
