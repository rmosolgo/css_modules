require 'test_helper'

class ViewHelperTest  < ActionDispatch::IntegrationTest
  def test_it_puts_class_names_in_the_page
    get "/page"

    pages_hash = "4317"
    assert_select "h1#pages_#{pages_hash}_header", "Header"
    assert_select "p.pages_#{pages_hash}_paragraph", "Paragraph"
    assert_select "a.pages_#{pages_hash}_link", "here"
  end
end
