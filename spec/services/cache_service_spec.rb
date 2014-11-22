require_relative('../rspec_helper')

describe CacheService do
  [McCache, ZkCache].each do |cache|
    CacheService.cache = cache

    before :all do
      @key = 'some_key'
      SdkLogger.logger .info("Cache implementation: #{CacheService.cache}")
    end

    before :each do
      CacheService.initialize
    end

    context 'initialize' do
      it 'initializes cache' do
        CacheService.initialize
        expect(CacheService.cache).not_to be_nil
      end

      it 'returns nil for CacheService.cache if exception happens' do
        allow(ConfigService).to receive(:load_config).and_raise('Something wrong')
        CacheService.initialize
        expect(CacheService.cache).to be_nil
      end
    end

    context 'read' do
      it 'calls read on the cache object' do
        expect(CacheService.cache).to receive(:read).once
        CacheService.read(@key)
      end

      it 'returns nil if CacheService.cache is nil' do
        CacheService.cache = nil
        expect(CacheService.cache).to receive(:read).never
        expect(CacheService.read(@key)).to be_nil
      end
    end

    context 'write' do
      it 'calls write on the cache object' do
        expect(CacheService.cache).to receive(:write).once
        CacheService.write(@key, 'Some data')
      end

      it 'returns nil if CacheService.cache is nil' do
        CacheService.cache = nil
        expect(CacheService.cache).to receive(:write).never
        expect(CacheService.write(@key, 'Some data')).to be_nil
      end
    end

    context 'delete' do
      it 'calls delete on the cache object' do
        expect(CacheService.cache).to receive(:delete).once
        CacheService.delete(@key)
      end

      it 'returns nil if CacheService.cache is nil' do
        CacheService.cache = nil
        expect(CacheService.cache).to receive(:delete).never
        expect(CacheService.delete(@key)).to be_nil
      end
    end
  end 
end
