require 'rspec'
require 'yaml'

require_relative '../lib/cache_service'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation 

end
