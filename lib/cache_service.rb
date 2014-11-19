require 'yaml'
require_relative 'services/config_service'

def load_gem_lib(sub_path)
  spec = Gem::Specification.find_by_name('cache_service')
  rb_files =  Dir.glob("#{spec.gem_dir}/lib/#{sub_path}/*.rb")
  rb_files.each { |rb_file| require rb_file }
rescue Exception => error
  # Who cares?
end

def proc_dir(dir)
  Dir[ File.join(dir, '**', '*') ].reject { |p| File.directory? p }
end


proc_dir('.').reject { |p| !p.ends_with?('.rb') }.each do |rb_file|
  unless (rb_file == './lib/cache_service.rb' || rb_file.starts_with?('./spec/'))
    require rb_file
    puts "require #{rb_file}"
  end
end