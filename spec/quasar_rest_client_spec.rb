require "spec_helper"

RSpec.describe QuasarRestClient do

  it { is_expected.to(respond_to(:configure)) }
  it { is_expected.to(respond_to(:config)) }
  it { is_expected.to(respond_to(:simple_query)) }
  it { is_expected.to(respond_to(:long_query)) }
  it { is_expected.to(respond_to(:get_data)) }
  it { is_expected.to(respond_to(:delete_data)) }

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
        .and_return("ran simple_query")
    end

    it { is_expected.to(eq("ran simple_query")) }
  end

  describe '#long_query' do
    subject { described_class.long_query("select * from `nowhere`", 'nowhere', limit: 10) }

    before do
      allow_any_instance_of(QuasarRestClient::Proxy).to receive(:long_query)
        .with(any_args)
        .and_return("ran long_query")
    end

    it { is_expected.to(eq("ran long_query")) }
  end
  describe '#get_data' do
    subject { described_class.get_data('nowhere') }

    before do
      allow_any_instance_of(QuasarRestClient::Proxy).to receive(:get_data)
        .with(any_args)
        .and_return("ran get_data")
    end

    it { is_expected.to(eq("ran get_data")) }
  end
  describe '#delete_data' do
    subject { described_class.delete_data('nowhere') }

    before do
      allow_any_instance_of(QuasarRestClient::Proxy).to receive(:delete_data)
        .with(any_args)
        .and_return("ran delete_data")
    end

    it { is_expected.to(eq("ran delete_data")) }
  end

end
