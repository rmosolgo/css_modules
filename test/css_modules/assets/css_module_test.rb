require "test_helper"

class CSSModulesJSTest < Minitest::Test
  ITEMS_LIST_ITEM = "items_5257_list-item"
  ITEMS_LIST_ITEM_PRODUCTION = "i5257list-item"

  def execjs_context
    @execjs_context ||= begin
      css_modules_js = Rails.application.assets["css_module.js"].to_s
      ExecJS.compile(css_modules_js)
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
    execjs_context.eval("CSSModule.environment = 'production'")
    js_name = execjs_context.eval("CSSModule('items', 'list-item')")
    execjs_context.eval("CSSModule.environment = 'development'")

    ruby_name = CSSModules::Transform::ProductionTransform.transform("items", "list-item")
    assert_equal(ITEMS_LIST_ITEM_PRODUCTION, ruby_name)
    assert_equal(ITEMS_LIST_ITEM_PRODUCTION, js_name)
  end

  def test_it_prints_the_current_env
    assert_equal :development, CSSModules.env
    assert_includes  Rails.application.assets["css_module.js"].to_s, '"development"'
  end

  def test_it_joins_modulized_names_with_plain_names
    js_name = execjs_context.eval("CSSModule('items', 'list-wrapper list-item', 'clearfix')")
    assert_equal("items_5257_list-wrapper items_5257_list-item clearfix", js_name)
  end


  def test_it_applies_no_transformation_when_the_module_name_is_null
    js_name = execjs_context.eval("CSSModule(null, 'list-wrapper list-item', 'clearfix')")
    assert_equal("list-wrapper list-item clearfix", js_name)
    js_name = execjs_context.eval("CSSModule(null)('list-wrapper list-item', 'clearfix')")
    assert_equal("list-wrapper list-item clearfix", js_name)
  end
end
