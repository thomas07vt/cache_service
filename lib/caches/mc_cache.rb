require 'dalli'
require 'net/http'
require 'net/https'

class McCache
  class << self
    def client
      @@client
    end

    def initialize
      @@config ||= ConfigService.load_config('memcached.yml')[ConfigService.environment]
      @@client ||= Dalli::Client.new(@@config['host'], @@config)
      cache_exists?
    rescue Exception => error
      puts("McCache.initialize error: #{error.message}")
      @@client = nil
    end #initialize

    def cache_exists?
    #   @@client.read('test')
    # rescue Exception => error
    #   @@client = nil
      Net::HTTP.get(URI("http://#{@@config['host']}"))
    rescue Errno::ECONNREFUSED => error
      puts "**** Error: #{error.message}"
      @@client = nil
    rescue Net::HTTPBadResponse => error
      # do nothing
    end

    # Cache API, mimics ActiveSupport::Cache::Store
    # http://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html
    def read(key, options = {})
      return unless client
      client.get(key, options)
    end

    def write(key, value, options = {})
      return unless client
      client.set(key, value, options[:expires_in], options)
    end

    def delete(key, options = {})
      return unless client
      deleted = read(key)
      client.delete(key)
      deleted
    end
  end #class methods

  initialize
end