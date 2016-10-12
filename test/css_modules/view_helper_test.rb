require 'test_helper'

class ViewHelperTest  < ActionDispatch::IntegrationTest
  def test_it_puts_class_names_in_the_page
    get "/page"
    assert_select "h1#pages_1035_header", "Header"
    assert_select "p.pages_1223_paragraph", "Paragraph"
    assert_select "a.pages_1446_link", "here"
  end
end
