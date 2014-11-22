require_relative('../rspec_helper')

describe McCache do
  before :all do
    McCache.initialize
    raise 'You must have memcached installed somewhere to run the tests' unless McCache.client
  end

  before :each do
    McCache.initialize
    @client = McCache.client
  end

  # This test initialize and the private init_zookeeper too
  context 'initialize' do
    it 'initializes the memcached client' do
      McCache.initialize
      expect(McCache.client).not_to be_nil 
    end

    it 'initializes the memcached client to nil if error happens' do
      allow(McCache).to receive(:cache_exists?).and_raise('Something wrong')
      McCache.initialize
      expect(McCache.client).to be_nil 
    end
  end

  context 'write' do
    it 'writes data to memcached' do
      McCache.write('test_key', 'Some data')
      expect(@client.get('test_key')).to eql('Some data')
    end

    it 'returns nil if McCache.client is nil' do
      expect(McCache).to receive(:client).and_return(nil)
      expect(McCache.write('test_key', 'Some data')).to be_nil
    end
  end

  context 'read' do
    it 'reads data from memcached' do
      @client.set('test_key', 'Some other data')
      expect(McCache.read('test_key')).to eql('Some other data')
    end

    it 'returns nil if the key does not exist' do
      expect(McCache.read('test_key')).to be_nil
    end

    it 'returns nil if the data is expired' do
      McCache.write('test_key', 'Some data', { expires_in: 1 })
      sleep 2
      expect(McCache.read('test_key')).to be_nil
    end

    it 'returns nil if McCache.client is nil' do
      expect(McCache).to receive(:client).and_return(nil)
      expect(McCache.read('test_key')).to be_nil
    end
  end

  context 'delete' do
    it 'deletes the object and returns it if the key exists' do
      McCache.write('other_test_key', 'Some data')
      deleted = McCache.delete('other_test_key')
      expect(McCache.read('other_test_key')).to be_nil
      expect(deleted).to eql('Some data')
    end

    it 'returns nil if the key does not exist' do
      deleted = McCache.delete('does_not_exist_test_key')
      expect(deleted).to eql(nil)
    end

    it 'returns nil if McCache.client is nil' do
      expect(McCache).to receive(:client).and_return(nil)
      expect(McCache.delete('test_key')).to be_nil
    end
  end
  
  after :each do
    @client.delete('test_key') if @client
  end
end