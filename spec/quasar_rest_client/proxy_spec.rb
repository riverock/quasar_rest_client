require "spec_helper"

RSpec.describe QuasarRestClient::Proxy do

  subject { described_class.new(sql, options) }

  let(:sql) { "SELECT * FROM `nowhere` WHERE skiffle = :skiffiliators" }
  let(:options) do
    {
      limit: 10,
      var: {
        "skiffilators" => "ben",
      }
    }
  end

  specify { expect(described_class).to respond_to(:get) }

  it { is_expected.to respond_to(:simple_query) }
  it { is_expected.to respond_to(:long_query) }
  it { is_expected.to respond_to(:get_data) }
  it { is_expected.to respond_to(:delete_data) }

  describe "#simple_query" do
    subject { super().simple_query }

    let(:params) do
      {
        :query=> {
          "q"=>"SELECT * FROM `nowhere` WHERE skiffle = :skiffiliators",
          "limit"=>10,
          "var.skiffilators"=>"ben".inspect,
        },
        :headers=>{
          "accept-encoding"=>"",
          "accept"=>"application/json"
        },
        :logger=>nil,
        :base_uri=>nil
      }
    end

    before do
      allow(described_class).to receive(:get).with("/query/fs",params)
        .and_return("ran query")
    end

    it { is_expected.to eq("ran query") }
  end

  describe "#long_query" do
    context "destination provided" do
      subject { super().long_query(destination: 'nowhere') }

      let(:params) do
        {
          :body=>"SELECT * FROM `nowhere` WHERE skiffle = :skiffiliators",
          :query=> {
            "limit"=>10,
            "var.skiffilators"=>"ben".inspect,
          },
          :headers=>{
            "accept-encoding"=>"",
            "accept"=>"application/json",
            "destination"=>"nowhere"
          },
          :logger=>nil,
          :base_uri=>nil
        }
      end

      before do
        expect(described_class).to receive(:post).with("/query/fs",params)
          .and_return("ran long query")
      end

      it { is_expected.to eq("ran long query") }
    end

    context "destination blank" do
      subject { super().long_query(destination: '') }
      it "raises an error" do
        expect{subject}.to raise_error(RuntimeError, /must provide a destination:/)
      end
    end
    context "destination not a string" do
      subject { super().long_query(destination: 17) }
      it "raises an error" do
        expect{subject}.to raise_error(RuntimeError, /must provide a destination:/)
      end
    end
    context "destination omitted" do
      subject { super().long_query() }
      it "raises an error" do
        expect{subject}.to raise_error(ArgumentError, /missing keyword: destination/)
      end
    end

  end

  describe "#get_data" do

    context "collection provided" do
      subject { super().get_data(collection: 'nowhere') }

      let(:params) do
        {
          :query=>{"limit"=>10},
          :headers=>{
            "accept-encoding"=>"",
            "accept"=>"application/json",
          },
          :logger=>nil,
          :base_uri=>nil
        }
      end

      before do
        expect(described_class).to receive(:get).with("/data/fs/nowhere",params)
          .and_return("ran get_data")
      end

      it { is_expected.to eq("ran get_data") }
    end
    context "collection blank" do
      subject { super().get_data(collection: '') }
      it "raises an error" do
        expect{subject}.to raise_error(RuntimeError, /must provide a collection:/)
      end
    end
    context "collection not a string" do
      subject { super().get_data(collection: 17) }
      it "raises an error" do
        expect{subject}.to raise_error(RuntimeError, /must provide a collection:/)
      end
    end
    context "collection omitted" do
      subject { super().get_data() }
      it "raises an error" do
        expect{subject}.to raise_error(ArgumentError, /missing keyword: collection/)
      end
    end
  end

    describe "#delete_data" do

    context "collection provided" do
      subject { super().delete_data(collection: 'nowhere') }

      let(:params) do
        {
          :headers=>{
            "accept-encoding"=>"",
            "accept"=>"application/json",
          },
          :logger=>nil,
          :base_uri=>nil
        }
      end

      before do
        expect(described_class).to receive(:delete).with("/data/fs/nowhere",params)
          .and_return("ran delete_data")
      end

      it { is_expected.to eq("ran delete_data") }
    end
    context "collection blank" do
      subject { super().delete_data(collection: '') }
      it "raises an error" do
        expect{subject}.to raise_error(RuntimeError, /must provide a collection:/)
      end
    end
    context "collection not a string" do
      subject { super().delete_data(collection: 17) }
      it "raises an error" do
        expect{subject}.to raise_error(RuntimeError, /must provide a collection:/)
      end
    end
    context "collection omitted" do
      subject { super().delete_data() }
      it "raises an error" do
        expect{subject}.to raise_error(ArgumentError, /missing keyword: collection/)
      end
    end
  end
end
