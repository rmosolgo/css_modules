require "test_helper"

class EngineTest < Minitest::Test
  def assert_transformed_asset_includes(asset_name, expected_content)
    transformed_asset = Rails.application.assets[asset_name].to_s
    assert_includes(transformed_asset, expected_content)
  end

  def test_it_processes_after_sass
    # It's compressed by Sass, too
    assert_transformed_asset_includes "events.css", "#events_3749_header{font-weight:bold}\n"
  end

  def test_it_works_with_scss
    assert_transformed_asset_includes "events2.css", ".events2_557_header{font-size:100px}\n"
  end

  def test_it_does_real_code
    assert_transformed_asset_includes "dialog.css", ".suggested-resources_4530_suggested-resource-row"
  end
end
