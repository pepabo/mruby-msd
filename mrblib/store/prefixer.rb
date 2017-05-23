module Msd
  class Store
    module Prefixer
      attr_accessor :key_prefix
      def has_prefix?
        key_prefix
      end

      def set_prefix(key)
        has_prefix? ? "#{key_prefix}#{key}" : key
      end
    end
  end
end
