require 'dalli'

class McCache
  class << self
    def client
      @@client
    end

    def initialize
      config = ConfigService.load_config('memcached.yml')[ConfigService.environment]
      @@client ||= Dalli::Client.new(config['host'], config)
    rescue => error
      SdkLogger.logger.error("McCache.initialize error: #{error.message}")
      @@client ||= Dalli::Client.new('localhost:11211', { host: 'localhost:11211',namespace: 'mc_cache', compress: true })
    end #initialize

    # Cache API, mimics ActiveSupport::Cache::Store
    # http://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html
    def read(key, options = {})
      client.get(key, options)
    end

    def write(key, value, options = {})
      client.set(key, value, options[:expires_in], options)
    end

    def delete(key, options = {})
      deleted = read(key)
      client.delete(key)
      deleted
    end
  end #class methods

  initialize
end