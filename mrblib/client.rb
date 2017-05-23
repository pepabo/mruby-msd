module Msd
  module Logger; end
  module Configuration; end
  module Connection; end

  class Client
    include Logger
    include Configuration
    include Connection
  end
end
