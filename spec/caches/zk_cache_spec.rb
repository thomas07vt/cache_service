require_relative('../rspec_helper')

describe ZkCache do
  before :all do
    @client = ZkCache.client
  end

  # This test initialize and the private init_zookeeper too
  context 'initialize' do
    it 'initializes the zookeeper client' do
      ZkCache.initialize
      expect(ZkCache.client).not_to be_nil 
    end

    it 'initializes the zookeeper client to local host default if error happens' do
      allow(ConfigService).to receive(:load_config).and_raise('Something wrong')
      ZkCache.initialize
      expect(ZkCache.client).not_to be_nil 
    end
  end

  context 'write' do
    it 'writes data to zookeeper' do
      ZkCache.write('/test_key', 'Some data')
      expect(@client.get(path: '/test_key')[:data]).to eql('Some data')
    end
  end

  context 'read' do
    it 'reads data from zookeeper' do
      ZkCache.write('/test_key', 'Some other data')
      expect(ZkCache.read('/test_key')).to eql('Some other data')
    end

    it 'returns nil if the key does not exist' do
      expect(ZkCache.read('/test_key')).to be_nil
    end

    it 'returns nil if the data is expired' do
      ZkCache.write('/test_key', 'Some data', { expires_in: 2 })
      sleep 3
      expect(ZkCache.read('/test_key')).to be_nil
    end
  end

  context 'delete' do
    it 'deletes the object and returns it if the key exists' do
      ZkCache.write('/other_test_key', 'Some data')
      deleted = ZkCache.delete('/other_test_key')
      expect(ZkCache.read('/other_test_key')).to be_nil
      expect(deleted).to eql('Some data')
    end

    it 'returns nil if the key does not exist' do
      deleted = ZkCache.delete('/does_not_exist_test_key')
      expect(deleted).to eql(nil)
    end
  end

  context 'expires?' do
    it 'returns true if data is nil' do
      expect(ZkCache.expires?(nil)).to eql(true)
    end

    it 'returns true if data is not a hash' do
      expect(ZkCache.expires?('abc')).to eql(true)
    end

    it 'returns true if data is expired' do
      expect(ZkCache.expires?({ 'last_read' => 1.hours.ago.to_s, 'expires_in' => 30.minutes})).to eql(true)
    end

    it 'returns false if data is not expired' do
      expect(ZkCache.expires?({ 'last_read' => 25.minutes.ago.to_s, 'expires_in' => 30.minutes})).to eql(false)
    end
  end

  context 'decode_data' do
    it 'returns a hash if data is a Hash.to_json' do
      h = { one: 1, two: 2 }
      expect(ZkCache.decode_data(h.to_json)).to eql({'one'=>1, 'two'=>2})
    end

    it 'returns data if data is not a json string' do
      expect(ZkCache.decode_data('Some string')).to eql('Some string')
    end
  end
  
  after :each do
    @client.delete(path: '/test_key')
  end
end