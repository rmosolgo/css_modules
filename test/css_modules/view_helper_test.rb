require 'test_helper'

class ViewHelperTest  < ActionDispatch::IntegrationTest
  def test_it_puts_class_names_in_the_page
    get "/page"
    assert_select "h1#cGFnZXM_pages_header", "Header"
    assert_select "p.cGFnZXM_pages_paragraph", "Paragraph"
    assert_select "a.cGFnZXM_pages_link", "here"
  end
end
