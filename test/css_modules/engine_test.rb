require "test_helper"

class EngineTest < Minitest::Test
  def assert_transformed_asset_includes(asset_name, expected_content)
    transformed_asset = Rails.application.assets[asset_name].to_s
    assert_includes(transformed_asset, expected_content)
  end

  def test_it_processes_after_sass
    # It's compressed by Sass, too
    assert_transformed_asset_includes "events.css", "#events_7311_header{font-weight:bold}"
    assert_transformed_asset_includes "events.css", "#events_7311_header:hover{text-decoration:underline}"
  end

  def test_it_works_with_scss
    assert_transformed_asset_includes "events2.css", ".events2_1159_header{font-size:100px}"
  end

  def test_it_does_real_code
    assert_transformed_asset_includes "dialog.css", ".suggested-resources_2653_suggested-resource-row"
    assert_transformed_asset_includes "dialog.css",
      ".resources_9015_info input.resources_9015_naked-field,.resources_9015_info select.resources_9015_naked-field,.resources_9015_info textarea.resources_9015_naked-field{margin:0 5px;padding:0 4px}"
  end
end
