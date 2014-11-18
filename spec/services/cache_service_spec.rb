require_relative('../rspec_helper')

describe CacheService do
  before :all do
    @cache = CacheService.cache
    @key = 'some_key'
  end

  context 'initialize' do
    it 'initializes cache' do
      CacheService.initialize
      expect(CacheService.cache).not_to be_nil
    end

    it 'returns McCache if exception happens' do
      allow(ConfigService).to receive(:load_config).and_raise('Something wrong')
      CacheService.initialize
      expect(CacheService.cache).to eql(McCache)
    end
  end

  context 'read' do
    it 'calls read on the cache object' do
      expect(@cache).to receive(:read).once
      CacheService.read(@key)
    end
  end

  context 'write' do
    it 'calls write on the cache object' do
      expect(@cache).to receive(:write).once
      CacheService.write(@key, 'Some data')
    end
  end

  context 'delete' do
    it 'calls delete on the cache object' do
      expect(@cache).to receive(:delete).once
      CacheService.delete(@key)
    end
  end
end
