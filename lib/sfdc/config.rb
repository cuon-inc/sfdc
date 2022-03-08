module Sfdc
  class << self
    require "forwardable"
    extend Forwardable

    def_delegators :@config, :logger, :logger=

    def config
      @config ||= Configuration.new do |config|
        config.logger = begin
          require "logger"
          ::Logger.new($stdout)
        end
      end
    end

    def configure
      yield config
    end
  end

  class Configuration
    attr_accessor :logger

    def initialize
      yield(self) if block_given?
    end
  end
end
