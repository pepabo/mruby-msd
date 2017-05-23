module Msd
  class Store
    module HashKeys
      attr_accessor :hash_keys
      def has_keys?
        hash_keys && !hash_keys.empty?
      end
    end
  end
end
