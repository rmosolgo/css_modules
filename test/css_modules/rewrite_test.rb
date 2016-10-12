require "test_helper"

class RewriteTest < Minitest::Test
  def assert_rewrite_module(original_css, expected_rewritten_css)
    actual_rewritten_css = CSSModules::Rewrite.rewrite_css(original_css)
    assert_equal(expected_rewritten_css, actual_rewritten_css)
  end

  def test_it_does_real_code
    real_code = "
/* line 1344, /home/vagrant/Code/resources/app/assets/stylesheets/all/dialog.css.sass */
:module(suggested-resources) .suggested-resource-container {
  background: #f8f7f6;
  border-radius: 2px;
  border: 1px solid #cccaca;
  width: 100%;
  margin-bottom: 6px;
  padding: 5px 10px;
}
/* line 1351, /home/vagrant/Code/resources/app/assets/stylesheets/all/dialog.css.sass */
:module(suggested-resources) .suggested-resource-row {
  padding: 5px 0px;
  border-bottom: 1px dotted #cccaca;
}
/* line 1354, /home/vagrant/Code/resources/app/assets/stylesheets/all/dialog.css.sass */
:module(suggested-resources) .suggested-resource-row:last-child {
  border-bottom: none;
}
"
    assert_rewrite_module(real_code, ".c3VnZ2VzdGVkLXJlc291cmNlcw_suggested-resources_suggested-resource-container {
  background: #f8f7f6;
  border-radius: 2px;
  border: 1px solid #cccaca;
  width: 100%;
  margin-bottom: 6px;
  padding: 5px 10px;
}
.c3VnZ2VzdGVkLXJlc291cmNlcw_suggested-resources_suggested-resource-row {
  padding: 5px 0px;
  border-bottom: 1px dotted #cccaca;
}
.c3VnZ2VzdGVkLXJlc291cmNlcw_suggested-resources_suggested-resource-row:last-child {
  border-bottom: none;
}")
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

  def test_it_doesnt_rewrite_bare_element_selectors
    before_css = ":module(item) span {\n  background: rbga(255, 255, 255, 0.8);\n}"
    after_css = "span {\n  background: rbga(255, 255, 255, 0.8);\n}"
    assert_rewrite_module before_css, after_css
  end

  def test_it_rewrites_nested_bare_element_selectors
    before_css = ":module(item) #container h1 {\n  background: rbga(255, 255, 255, 0.8);\n}"
    after_css = "#aXRlbQ_item_container h1 {\n  background: rbga(255, 255, 255, 0.8);\n}"
    assert_rewrite_module before_css, after_css
  end

  def test_it_rewrites_immediate_child_selectors
    before_css = ":module(item) .parent > .child {\n  background: rbga(255, 255, 255, 0.8);\n}"
    after_css = ".aXRlbQ_item_parent > .aXRlbQ_item_child {\n  background: rbga(255, 255, 255, 0.8);\n}"
    assert_rewrite_module before_css, after_css
  end

  def test_it_rewrites_pseudo_selectors
    before_css = ":module(item) .clearfix:after {\n content: \" \";\n}"
    after_css = ".aXRlbQ_item_clearfix:after {\n  content: \" \";\n}"
    assert_rewrite_module before_css, after_css
  end

  def test_it_leaves_plain_css_alone
    before_css = ":module(a) .b {\n  display: none;\n}\n #footer { position: relative }"
    after_css = ".YQ_a_b {\n  display: none;\n}\n#footer {\n  position: relative;\n}"
    assert_rewrite_module before_css, after_css
  end
end
