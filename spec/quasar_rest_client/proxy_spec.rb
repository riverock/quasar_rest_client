require "spec_helper"

RSpec.describe QuasarRestClient::Proxy do

  subject { described_class.new(sql, options) }

  let(:sql) { "SELECT * FROM `nowhere` WHERE skiffle = :skiffiliators" }
  let(:options) do
    {
      limit: 10,
      var: {
        "skiffilators" => "ben"
      }
    }
  end

  specify { expect(described_class).to respond_to(:get) }

  it { is_expected.to respond_to(:simple_query) }

  describe "#simple_query" do
    subject { super().simple_query }
    
    let(:params) do
      {
        :query=> {
          "q"=>"SELECT * FROM `nowhere` WHERE skiffle = :skiffiliators",
          "limit"=>10,
          "var"=>{
            "skiffilators"=>"ben"
          }
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
end
