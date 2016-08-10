require "spec_helper"

RSpec.describe QuasarRestClient do

  describe "#configure yields configuration block" do
    before do
      described_class.configure do |config|
        config.foo = 'bar'
        config.baz = 'quux'
      end
    end
    
    context 'dynamic method foo' do
      subject { described_class.config.foo }
      it { is_expected.to eq('bar') }
    end

    context 'dynamic method quux' do
      subject { described_class.config.baz }
      it { is_expected.to eq('quux') }
    end
  end

  describe '#simple_query' do
    subject { described_class.simple_query("select * from `nowhere`", limit: 10) }

    before do
      allow_any_instance_of(QuasarRestClient::Proxy).to receive(:simple_query)
          .with(any_args)
          .and_return("ran query")
    end

    it { is_expected.to(eq("ran query")) }
  end

end
