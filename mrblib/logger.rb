module Msd
  module Logger
    def _send(method, message)
      if config.logger
        config.logger.send(method, message)
      else
        puts message
      end
    end

    def info(message)
      _send(:info, message)
    end

    def warn(message)
      _send(:warn, message)
    end

    def error(message)
      _send(:error, message)
    end

    def critical(message)
      _send(:critical, message)
    end
  end
end
