require "test_helper"

class RewriteTest < Minitest::Test
  def assert_rewrite_module(original_css, expected_rewritten_css)
    actual_rewritten_css = CSSModules::Rewrite.rewrite_css(original_css)
    assert_equal(expected_rewritten_css, actual_rewritten_css)
  end

  def test_it_rewrites_class_selectors
    before_css = ":module(item) .title { color: red; }"
    after_css = ".item_5142_title {\n  color: red; }\n"
    assert_rewrite_module before_css, after_css
  end

  def test_it_rewrites_id_selectors
    before_css = ":module(item) #container {\n  background: rbga(255, 255, 255, 0.8);\n}"
    after_css = "#item_5142_container {\n  background: rbga(255, 255, 255, 0.8); }\n"
    assert_rewrite_module before_css, after_css
  end

  def test_it_rewrites_nested_selectors
    before_css = ":module(item) #container .title {\n  background: rbga(255, 255, 255, 0.8);\n}"
    after_css = "#item_5142_container .item_5142_title {\n  background: rbga(255, 255, 255, 0.8); }\n"
    assert_rewrite_module before_css, after_css
  end

  def test_it_doesnt_rewrite_bare_element_selectors
    before_css = ":module(item) span {\n  background: rbga(255, 255, 255, 0.8);\n}"
    after_css = "span {\n  background: rbga(255, 255, 255, 0.8); }\n"
    assert_rewrite_module before_css, after_css
  end

  def test_it_rewrites_nested_bare_element_selectors
    before_css = ":module(item) #container h1 {\n  background: rbga(255, 255, 255, 0.8);\n}"
    after_css = "#item_5142_container h1 {\n  background: rbga(255, 255, 255, 0.8); }\n"
    assert_rewrite_module before_css, after_css

    before_css = ":module(item) h1#container {\n  background: rbga(255, 255, 255, 0.8);\n}"
    after_css = "h1#item_5142_container {\n  background: rbga(255, 255, 255, 0.8); }\n"
    assert_rewrite_module before_css, after_css
  end

  def test_it_rewrites_immediate_child_selectors
    before_css = ":module(item) .parent > .child {\n  background: rbga(255, 255, 255, 0.8);\n}"
    after_css = ".item_5142_parent > .item_5142_child {\n  background: rbga(255, 255, 255, 0.8); }\n"
    assert_rewrite_module before_css, after_css
  end

  def test_it_rewrites_pseudo_selectors
    before_css = ":module(item) .clearfix:after {\n content: \" \";\n}"
    after_css = ".item_5142_clearfix:after {\n  content: \" \"; }\n"
    assert_rewrite_module before_css, after_css
  end

  def test_it_leaves_plain_css_alone
    before_css = ":module(a) .b {\n  display: none;\n}\n #footer { position: relative }"
    after_css = ".a_97_b {\n  display: none; }\n\n#footer {\n  position: relative; }\n"
    assert_rewrite_module before_css, after_css
  end

  def test_it_leaves_media_queries_alone
    before_css = "@media (max-width: 767px) { .mobile-topbar { display: block; } }"
    after_css = "@media (max-width: 767px) {\n  .mobile-topbar {\n    display: block; } }\n"
    assert_rewrite_module before_css, after_css
  end
end
