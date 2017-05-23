module Msd
  module Connection
    def fetch(key)
      setup
      result = nil
      stores.each do |s|
        result = safe_run(
          Proc.new { s.fetch(key) },
          Proc.new { s.before_fetch_retry }
        )
        if result && result != '[null]' && !(result.is_a?(Array) && result.all? {|r| !r })
          cache(key, result, s)
          break
        end
      end
      result
    end

    def purge(key)
      setup
      stores.each do |s|
        safe_run(
          Proc.new { s.purge(key) },
          Proc.new { s.before_purge_retry }
        )
      end
    end


    private
    def setup
      stores.each do |s|
        s.hash_keys = config.hash_keys

        safe_run(
          Proc.new { s.connect unless s.connect? },
          Proc.new { s.before_connect_retry }
        )
      end
    end

    def cache(key, value, klass)
      stores.each do |s|
        safe_run(
          Proc.new {
            break if s == klass
            s.cache(key, value)
          },
          Proc.new { s.before_cache_retry }
        )
      end
    end

    def safe_run(main, before)
      begin
        main.call
      rescue => e
        c ||= 0
        if config.retry_count > c
          warn("retry:#{e.message}")
          usleep config.retry_usleep
          begin
            before.call
          rescue => be
            warn("before call:#{be.message}")
          end
          c += 1
          retry
        end
        raise e
      end
    end

    def stores
        config.stores
    end
  end
end
