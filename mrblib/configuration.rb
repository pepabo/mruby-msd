module Msd
  module Configuration
    def config
      @config ||= Config.new
    end

    def configure
      yield config
    end

    class Config
      attr_accessor :retry_count, :retry_usleep, :logger, :stores, :hash_keys
      def initialize
        @retry_count = 5
        @retry_usleep = 3000
      end
    end
  end
end
