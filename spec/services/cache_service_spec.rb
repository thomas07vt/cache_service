require_relative('../rspec_helper')

describe CacheService do
  [McCache, ZkCache].each do |cache|
    CacheService.cache = cache

    before :all do
      @key = 'some_key'

      SdkLogger.logger .info("Cache implementation: #{CacheService.cache}")
    end

    context 'initialize' do
      it 'initializes cache' do
        CacheService.initialize
        expect(CacheService.cache).not_to be_nil
      end

      it 'returns a cache if exception happens' do
        allow(ConfigService).to receive(:load_config).and_raise('Something wrong')
        CacheService.initialize
        expect(CacheService.cache).not_to be_nil
      end

      it 'returns McCache if CacheService.cache is nil and exception happens' do
        allow(ConfigService).to receive(:load_config).and_raise('Something wrong')
        CacheService.cache = nil
        CacheService.initialize
        expect(CacheService.cache).to eql(McCache)
        CacheService.cache = cache
      end
    end

    context 'read' do
      it 'calls read on the cache object' do
        expect(cache).to receive(:read).once
        CacheService.read(@key)
      end
    end

    context 'write' do
      it 'calls write on the cache object' do
        expect(cache).to receive(:write).once
        CacheService.write(@key, 'Some data')
      end
    end

    context 'delete' do
      it 'calls delete on the cache object' do
        expect(cache).to receive(:delete).once
        CacheService.delete(@key)
      end
    end
  end 
end
