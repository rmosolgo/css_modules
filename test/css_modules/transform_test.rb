require "test_helper"

class TransformTest < Minitest::Test
  class DevelopmentTransformTest < Minitest::Test
    def test_it_concats_hash_and_full_name
      assert_equal "events_9896_index", CSSModules::Transform::DevelopmentTransform.transform("events", "index")
      assert_equal "event_1027_index", CSSModules::Transform::DevelopmentTransform.transform("event", "index")
    end
  end

  class ProductionTransformTest < Minitest::Test
    def test_it_concats_hash_and_prefix
      assert_equal "e9896i", CSSModules::Transform::ProductionTransform.transform("events", "index")
      assert_equal "e1027i", CSSModules::Transform::ProductionTransform.transform("event", "index")
    end
  end
end
