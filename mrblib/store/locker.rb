module Msd
  module Store
    module Locker
      def try_lock_do(&block)
        begin
          @mutex.try_lock_loop(@retry_time, @retry_time * @retry_count, &block)
        ensure
          @mutex.unlock
        end
      end
    end
  end
end
