require "test_helper"

class ProcessorTest < Minitest::Test
  def assert_transformed_asset_includes(asset_name, expected_content)
    transformed_asset = Rails.application.assets[asset_name].to_s
    assert_includes(transformed_asset, expected_content)
  end

  def test_it_uses_file_name_as_module_name
    assert_transformed_asset_includes "pages.css", ".cGFnZXM_pages_list-item{background-color:beige;font-size:1.3em}"
    assert_transformed_asset_includes "pages.css", ".cGFnZXM_pages_list-item a{color:aliceblue}"
  end

  def test_it_processes_after_sass
    # It's compressed by Sass, too
    assert_transformed_asset_includes "events.css", "#ZXZlbnRz_events_header{font-weight:bold}\n"
  end
end
