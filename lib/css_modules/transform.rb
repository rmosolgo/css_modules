module CSSModules
  module Transform
    # Hash outputs will be within the range `0..HASH_LIMIT-1`
    HASH_LIMIT = 10009
    # How big of a chunk should we use for folding over the string?
    SUM_SIZE = 4

    # Generate a short, random-ish token for `input_string`.
    # This has to be replicable in JS.
    # Ruby's `#hash` is randomly seeded, so we can't reuse that!
    # @param input_string [String] A string to hash
    # @return [String] a deterministic output for `input_string`
    def self.compute_hash(input_string)
      bytes_count = 0
      string_sum = 0

      input_string.each_byte do |byte|
        string_sum += byte * (256 ** bytes_count)
        bytes_count += 1
        bytes_count %= SUM_SIZE
      end

      string_sum % HASH_LIMIT
    end

    module DevelopmentTransform
      def self.transform(module_name, selector_name)
        "#{module_name}_#{Transform.compute_hash(module_name)}_#{selector_name}"
      end
    end

    module ProductionTransform
      def self.transform(module_name, selector_name)
        "#{module_name[0]}#{Transform.compute_hash(module_name)}#{selector_name}"
      end
    end
  end
end
