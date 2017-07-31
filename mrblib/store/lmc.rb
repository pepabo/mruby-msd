module Msd::Store::Prefixer; end
module Msd::Store::Locker; end

module Msd
  class Store
    class Lmc
      include HashKeys
      include Prefixer
      include Locker
      def initialize(namespace, retry_time=10000, retry_count=10)
        @namespace = namespace
        @mutex = Mutex.new(:global => true)
        @retry_time = retry_time
        @retry_count = retry_count
      end

      def connect
        @_c ||= ::Cache.new :namespace => @namespace
      end

      def connect?
        @_c
      end

      def drop
        @_c = nil
        ::Cache.drop :namespace => @namespace, :force => true
      end

      def fetch(key)
        key = set_prefix(key)
        connect unless connect?
        result = nil
        try_lock_do do
          if has_keys?
            begin
              result = JSON.parse(@_c[key])
            rescue
              result = @_c[key]
            end
          else
            result = @_c[key]
          end
        end
        result
      end

      def cache(key, val)
        key = set_prefix(key)
        connect unless connect?
        try_lock_do do
          if has_keys?
            @_c[key] = val.to_json
          else
            @_c[key] = val
          end
        end
      end

      def purge(key)
        try_lock_do do
          key = set_prefix(key)
          connect unless connect?
          @_c.delete(key)
        end
      end

      alias_method :before_connect_retry, :drop
      alias_method :before_cache_retry, :drop
      alias_method :before_fetch_retry, :drop
      alias_method :before_purge_retry, :drop
    end
  end
end
