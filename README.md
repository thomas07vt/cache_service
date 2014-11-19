### cache_service
[![Gem Version](https://badge.fury.io/rb/cache_service.svg)](http://badge.fury.io/rb/cache_service)

This is [**Ruby**](https://www.ruby-lang.org/) gem that is used to provide caching facility.<br/>
It can be used with any caching mechanism, as long as the caching mechanism implements these functions:
```
  read(key, options = {})
  write(key, value, options = {})
  delete(key, options = {})
```

### Built-in cache support
This gem comes with built-in [**memcached**](http://memcached.org/)  and [**Zookeeper**](http://zookeeper.apache.org) support:<br/>
**1 - Memcached:** [**mc_cache.rb**](https://github.com/linhchauatl/cache_service/blob/master/lib/caches/mc_cache.rb)

In order to use the built-in memcached support, you must have:
- [**memcached**](http://memcached.org/) running on your local machine or on a network that your application can access.
- Modify the file [**memcached.yml**](https://github.com/linhchauatl/cache_service/blob/master/conf/memcached.yml) to suit your server layout and put the file in the directory **conf** or **config** of your application.

**2 - Zookeeper:** [**zk_cache.rb**](https://github.com/linhchauatl/cache_service/blob/master/lib/caches/zk_cache.rb)
In order to use the built-in Zookeeper support, you must have:
- [**Zookeeper**](http://zookeeper.apache.org) running on your local machine or on a network that your application can access.
- Modify the file [**zookeeper.yml**](https://github.com/linhchauatl/cache_service/blob/master/conf/zookeeper.yml) to suit your server layout and put the file in the directory **conf** or **config** of your application.


### Usage
In the **Gemfile** of your application, write:<br/>
```
gem 'cache_service'
```

<br/>
Or you can build the gem locally:<br/>
```
git clone git@github.com:linhchauatl/cache_service.git

cd cache_service

gem build cache_service.gemspec

gem install cache_service-<VERSION>.gem
```

In your code:
```
require 'cache_service'
```

Afterward you can call:<br/>
```
  CacheService.read(key, options = {})
  CacheService.write(key, value, options = {})
  CacheService.delete(key, options = {})
```
[**CacheService**](https://github.com/linhchauatl/cache_service/blob/master/lib/services/cache_service.rb) automatically uses the cache mechanism specified in [**cache_config.yml**](https://github.com/linhchauatl/cache_service/blob/master/conf/cache_config.yml)

### Provide your own caching mechanism
Your cache must be written to have the following methods:
```
  read(key, options = {})
  write(key, value, options = {})
  delete(key, options = {})
```

The **options** can be empty. But if you want to support time-based expiration, it must has the key `:expires_in`, for example:
```
{ expires_in : 3600 }
```

The number is the number in seconds.<br/>
Your `read` and `write` methods must be able to handle the expiration. If your underlying caching mechanism does not support time-based expiration, you must write code in `read` and `write` to handle it.

After you build your own cache implementation, you can use the file [**cache_config.yml**](https://github.com/linhchauatl/cache_service/blob/master/conf/cache_config.yml) to configure what cache the [**CacheService**](https://github.com/linhchauatl/cache_service/blob/master/lib/services/cache_service.rb) should use, based on environments.

The file **cache_config.yml** must be put in the directory **conf** or **config** of your own application to take effect.
