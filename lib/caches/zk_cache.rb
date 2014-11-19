require 'active_support'
require 'active_support/core_ext'
require 'zookeeper'

class ZkCache
  class << self

    def client
      @@client
    end

    def initialize
      config = ConfigService.load_config('zookeeper.yml')[ConfigService.environment]
      @@client ||= Zookeeper.new(config['host'])
    rescue => error
      SdkLogger.logger.error("ZkCache.initialize error: #{error.message}")
      @@client ||= Zookeeper.new('localhost:2181')
    end #initialize


    # Cache API, mimics ActiveSupport::Cache::Store
    # http://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html
    def read(key, options = {})
      key = process_key(key)
      result = client.get(path: key)[:data]
      result = decode_data(result)

      return result unless result.is_a?(Hash)
      
      sym_data = result.with_indifferent_access
      return sym_data unless sym_data[:zk_cache_data].present?
      
      sym_data = sym_data[:zk_cache_data]
      return nil if expires?(sym_data)

      sym_data[:value]
    end

    def write(key, value, options = {})
      key = process_key(key)
      init_key(key, nil)
      written_value = value
      if options[:expires_in].to_i > 0
        written_value = { zk_cache_data: { 
                                            value: value, 
                                            expires_in: (options[:expires_in].to_i),
                                            last_read: Time.now
                                          } 
                        }.to_json
      end

      client.set(path: key, data: written_value)
    end

    def delete(key, options = {})
      key = process_key(key)
      deleted = read(key)
      client.delete(path: key)
      deleted
    end

    def decode_data(data)
      ActiveSupport::JSON.decode(data)
    rescue => error
      data
    end

    def expires?(data)
      return true if (data.nil? || !data.is_a?(Hash))
      data = data.with_indifferent_access
      return DateTime.parse(data[:last_read]).to_i + data[:expires_in].to_i < Time.now.to_i
    end

    private

    def init_key(key, data)
      process_key(key)
    
      if @@client.get(path: key)[:data].nil?
        SdkLogger.logger.info("Create zookeeper path #{key} ...")
        @@client.create(path: key, data: data)
      end
    end

    def process_key(key)
      key = "/#{key}" unless key.starts_with?('/')
      key
    end

  end #class methods

  initialize
end