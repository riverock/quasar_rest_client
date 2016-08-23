require "spec_helper"

module QuasarRestClient

  class TestClass
    include MogrifyVars
  end

  RSpec.describe MogrifyVars do
    let(:vars) do
      {
        var:
        {
          "skiffilators" => "ben",
          "now" => Time.new(2016,1,1,11,15,45),
          "today" => Date.new(2016,2,2),
          "timestamp" => DateTime.new(2016,3,3,10,27,06),
          "count" => 12,
          "many" => [1,2,3],
        }
      }
    end

    let(:mogrified_vars) do
      {
        "var.skiffilators" => "ben".inspect,
        "var.now" => "TIME '11:15:45'",
        "var.today" => "DATE '2016-02-02'",
        "var.timestamp" => "TIMESTAMP '2016-03-03 10:27:06'",
        "var.count" => 12,
        "var.many" => "[1, 2, 3]"
      }
    end
    subject { TestClass.new.mogrify_vars(vars) }
    it { is_expected.to(eq(mogrified_vars))}
  end
end
