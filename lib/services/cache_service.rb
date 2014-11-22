require_relative './config_service'
require_relative './sdk_logger'

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
      @@cache ||= eval(config['cache'])
      SdkLogger.logger = eval(config['logger']) if config['logger'].present?
    rescue Exception => error
      puts("Error #{error.message}")
      @@cache = nil
    end

    def read(key, options = {})
      return nil unless cache
      cache.read(key, options)
    end

    def write(key, value, options = {})
      return nil unless cache
      cache.write(key, value, options)
    end

    def delete(key, options = {})
      return nil unless cache
      cache.delete(key, options)
    end
  end #class methods

  initialize
end
