require_relative('../rspec_helper')

describe ConfigService do
  context 'load_config' do
    it 'loads existing config file' do
      config = ConfigService.load_config('cache_config.yml')
      expect(config).not_to be_nil
      expect(config.is_a? Hash).to eql(true)
    end

    it 'raises error if the conf directory and config directory do not exist or the config file does not exist' do
      allow(File).to receive(:exist?).and_return(false)
      expect {ConfigService.load_config('cache_config.yml')}.to raise_error
    end
  end

  context 'environment' do
    after :each do
      ENV['RACK_ENV'] = 'test'
    end

    it 'returns test by default while running test' do
      expect(ConfigService.environment).to eql('test')
    end

    it 'returns local if the environment is not set' do
      ENV['RACK_ENV'] = nil
      expect(ConfigService.environment).to eql('local')
    end

    it 'returns correct value based on environment variable' do
      ENV['RACK_ENV'] = 'dummy'
      expect(ConfigService.environment).to eql('dummy')
    end
  end
end