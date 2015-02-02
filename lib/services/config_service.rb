require 'active_support'
require 'active_support/core_ext'

class ConfigService
  class << self
    def load_config(config_file_name)
      app_root = (defined? APP_ROOT)? APP_ROOT : File.expand_path('.')
      
      config_file = nil
      ['conf', 'config'].each do |sub_path|
        if File.exist?("#{app_root}/#{sub_path}/#{config_file_name}")
          config_file = "#{app_root}/#{sub_path}/#{config_file_name}"
          break
        end
      end
      
      raise("NON-Fatal: #{config_file_name} file not found. Ignoring cache type.") unless config_file

      YAML.load_file(config_file)
    end

    def environment
      return Rails.env if defined? Rails
      return ENV['RACK_ENV'] if ENV['RACK_ENV'].present?
      'local'
    rescue => error
      'local'
    end
  end # class methods
end