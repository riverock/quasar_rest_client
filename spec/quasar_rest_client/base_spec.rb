require "spec_helper"

RSpec.describe QuasarRestClient::Base do

  describe '.config' do
    it "starts empty and retains values" do
      # Must be run in one test to ensure ordering
      expect(described_class.config.public_methods(false)).to be_empty
      described_class.config.foo = 'bar'
      expect(described_class.config.public_methods(false)).not_to be_empty
      expect(described_class.config.foo).to eq("bar")
    end
  end


end
