require "test_helper"

class TransformTest < Minitest::Test
  class DevelopmentTransformTest < Minitest::Test
    def test_it_concats_hash_and_full_name
      assert_equal "events_7311_index", CSSModules::Transform::DevelopmentTransform.transform("events", "index")
      assert_equal "event_7898_index", CSSModules::Transform::DevelopmentTransform.transform("event", "index")
    end
  end

  class ProductionTransformTest < Minitest::Test
    def test_it_concats_hash_and_prefix
      assert_equal "e7311index", CSSModules::Transform::ProductionTransform.transform("events", "index")
      assert_equal "e7898index", CSSModules::Transform::ProductionTransform.transform("event", "index")
    end

    def test_it_preserves_last_child
      assert_equal "e7311item", CSSModules::Transform::ProductionTransform.transform("events", "item")
      assert_equal "e7311item:last-child", CSSModules::Transform::ProductionTransform.transform("events", "item:last-child")
    end
  end
end
