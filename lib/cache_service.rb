require 'yaml'
require_relative 'services/config_service'

def load_gem_lib(sub_path)
  spec = Gem::Specification.find_by_name('cache_service')
  rb_files =  Dir.glob("#{spec.gem_dir}/lib/#{sub_path}/*.rb")
  rb_files.each { |rb_file| require rb_file }
rescue Exception => error
  # Who cares?
end

['caches', 'services'].each do |sub_path|
  load_gem_lib(sub_path)
  rb_files =  Dir.glob("#{File.expand_path('.')}/lib/#{sub_path}/*.rb")
  rb_files.each { |rb_file| require rb_file }  
end