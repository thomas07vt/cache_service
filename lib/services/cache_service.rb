require_relative './config_service'

class CacheService
  class << self
    def cache
      @@cache
    end

    def cache=(other_cache)
      @@cache = other_cache
    end

    def initialize
      config = ConfigService.load_config('cache_config.yml')[ConfigService.environment]
      # Load all the existing caches in the system, outside of the gem
      Dir.glob("#{File.expand_path('.')}/caches/*.rb").each { |rb_file| require rb_file }
      @@cache ||= Object.const_get(config['cache'])
      SdkLogger.logger = Object.const_get(config['logger']) if config['logger'].present?
    rescue => error
      @@cache ||= McCache
    end

    def read(key, options = {})
      cache.read(key, options)
    end

    def write(key, value, options = {})
      cache.write(key, value, options)
    end

    def delete(key, options = {})
      cache.delete(key, options)
    end
  end #class methods

  initialize
end
