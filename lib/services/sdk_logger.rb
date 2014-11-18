require 'logger'

class SdkLogger
  @@logger ||= Logger.new(STDOUT)
  class << self
    def logger
      @@logger
    end

    def logger=(other_logger)
      @@logger = other_logger
    end
  end
end