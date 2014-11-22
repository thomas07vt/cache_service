Gem::Specification.new do |s|
  s.name        = 'cache_service'
  s.version     = '1.0.4'
  s.summary     = "A gem for cache facility"
  s.description = "A gem for cache facility"
  s.authors     = ['Linh Chau']
  s.email       = 'chauhonglinh@gmail.com'
  s.files       = [
                    './cache_service.gemspec', 'lib/cache_service.rb',
                    'lib/services/config_service.rb', 'lib/services/cache_service.rb', 'lib/services/sdk_logger.rb',
                    'lib/caches/mc_cache.rb', 'lib/caches/zk_cache.rb'
                  ]
  s.homepage    = 'https://github.com/linhchauatl/cache_service'
  s.license     = 'MIT'
  s.add_runtime_dependency 'logging', '~> 0'
  s.add_runtime_dependency 'activesupport'
  s.add_runtime_dependency 'dalli', '~> 0'  

  s.add_development_dependency 'rspec', '~> 3.1'
end