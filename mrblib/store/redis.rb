module Msd
  class Store
    class Redis
      include HashKeys
      include Prefixer
      def initialize(host=nil, port=nil, lifetime=300,timeout=1)
        @host = host || ::ENV['REDIS_HOST'] || '127.0.0.1'
        @port = port || ::ENV['REDIS_PORT'] || 6379
        @lifetime = lifetime
        @timeout = timeout
        @klass = ::Redis
      end

      def connect
        @_c ||= @klass.new(@host, @port, @timeout)
      end

      def connect?
        @_c.ping
      rescue
        false
      end

      def close
        @_c.close
      rescue
        @c = nil
      end

      def fetch(key)
        key = set_prefix(key)
        connect unless connect?
        if has_keys?
          v = @_c.hmget(key, *(hash_keys))
          if !(v.is_a?(Array) && v.all? {|r| !r })
            r = {}
            hash_keys.each_with_index do |h,index|
              r[h] = v[index].to_s
            end
            r
          end
        else
          @_c[key]
        end
      end

      def cache(key, val)
        key = set_prefix(key)
        connect unless connect?
        if has_keys?
          @_c.hmset(key, *(val.to_a.flatten))
        else
          @_c[key] = val
        end
        @_c.expire(key, @lifetime)
      end

      def purge(key)
        key = set_prefix(key)
        connect unless connect?
        @_c.del(key)
      end

      alias_method :before_connect_retry, :close
      alias_method :before_cache_retry, :close
      alias_method :before_fetch_retry, :close
      alias_method :before_purge_retry, :close

      def set_mock
        @klass = Mock
      end

      class Mock
        def initialize(host, port, timeout)
          @c = true
        end

        def close
          @c = false
          true
        end

        def ping
          @c
        end

        def expire(key, lifetime)
          raise "Lifetime needs to be 300 seconds" if 300 != lifetime
        end

        def[]=(k,v)
          @_cache ||= {}
          @_cache[k] = v
        end

        def[](k)
          @_cache ||= {}
          @_cache[k]
        end
      end
    end
  end
end
