require "test_helper"

class RewriteTest < Minitest::Test
  def assert_rewrite_module(original_css, expected_rewritten_css)
    actual_rewritten_css = CSSModules::Rewrite.rewrite_css(original_css)
    assert_equal(expected_rewritten_css, actual_rewritten_css)
  end


  def test_it_rewrites_class_selectors
    assert_rewrite_module ":module(item) .title { color: red; }", ".aXRlbQ_item_title {\n  color: red;\n}"
  end

  def test_it_rewrites_id_selectors
    before_css = ":module(item) #container {\n  background: rbga(255, 255, 255, 0.8);\n}"
    after_css = "#aXRlbQ_item_container {\n  background: rbga(255, 255, 255, 0.8);\n}"
    assert_rewrite_module before_css, after_css
  end

  def test_it_rewrites_nested_selectors
    before_css = ":module(item) #container .title {\n  background: rbga(255, 255, 255, 0.8);\n}"
    after_css = "#aXRlbQ_item_container .aXRlbQ_item_title {\n  background: rbga(255, 255, 255, 0.8);\n}"
    assert_rewrite_module before_css, after_css
  end

  def test_it_rewrites_bare_element_selectors
    before_css = ":module(item) span {\n  background: rbga(255, 255, 255, 0.8);\n}"
    after_css = ".aXRlbQ_item span {\n  background: rbga(255, 255, 255, 0.8);\n}"
    assert_rewrite_module before_css, after_css
  end

  def test_it_rewrites_nested_bare_element_selectors
    before_css = ":module(item) #container h1 {\n  background: rbga(255, 255, 255, 0.8);\n}"
    after_css = "#aXRlbQ_item_container h1 {\n  background: rbga(255, 255, 255, 0.8);\n}"
    assert_rewrite_module before_css, after_css
  end

  def test_it_rewrites_immediate_child_selectors
    before_css = ":module(item) ul > li {\n  background: rbga(255, 255, 255, 0.8);\n}"
    after_css = ".aXRlbQ_item ul > li {\n  background: rbga(255, 255, 255, 0.8);\n}"
    assert_rewrite_module before_css, after_css
  end

  def test_it_rewrites_pseudo_selectors
    before_css = ":module(item) .clearfix:after {\n content: \" \";\n}"
    after_css = ".aXRlbQ_item_clearfix:after {\n  content: \" \";\n}"
    assert_rewrite_module before_css, after_css
  end

  def test_it_leaves_globals_alone
    before_css = ":module(item) :global #footer {\n position: relative;\n}"
    after_css = "#footer {\n  position: relative;\n}"
    assert_rewrite_module before_css, after_css
  end

  def test_it_accepts_module_overrides
    before_css = ":module(item) :module(layout) #footer { position: relative }"
    after_css = "#bGF5b3V0_layout_footer {\n  position: relative;\n}"
    assert_rewrite_module before_css, after_css
  end

  def test_it_leaves_plain_css_alone
    before_css = "#footer { position: relative }"
    after_css = "#footer {\n  position: relative;\n}"
    assert_rewrite_module before_css, after_css
  end
end
