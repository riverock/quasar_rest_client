#!/usr/bin/env ruby

require "live_spec_helper"
require "logger"
require 'ostruct'
require "erb"
require "yaml"

def read_config(file = File.join(File.dirname(__FILE__), 'config', 'config.yml'))
  conf = YAML.load(ERB.new(File.read(file)).result)
  OpenStruct.new(conf)
end

def show_response(resp)
  "response code:      #{resp.code} \n" +
    "response request:   #{resp.request.uri}"
end

RSpec.describe "Live Testing" do
  let(:config) { read_config }
  let!(:collection_path) { ["", config.mount, config.parent, config.collection].join('/') }
  let!(:new_collection_path) { ["", config.mount, config.parent, config.new_collection].join('/') }
  let!(:endpoint) { "http://#{config.endpoint_host}:#{config.endpoint_port}" }
  let!(:sql_format) { "SELECT %s FROM `#{collection_path}` WHERE #{config.where_clause}" }
  let!(:sql_count) { sql_format % "count(*)" }
  let!(:sql_fetch) { sql_format % "*" }
  let!(:logger) { nil }

  before do
    QuasarRestClient.config.endpoint = endpoint
    QuasarRestClient.config.logger = logger
  end

  it "count_query" do
    resp = QuasarRestClient.simple_query(sql_count, var: config.vars)
    expect(resp.code).to(eq(200), show_response(resp))
  end

  it "fetch_query" do
    resp  = QuasarRestClient.simple_query(sql_fetch, limit: 2, var: config.vars)
    expect(resp.code).to(eq(200), show_response(resp))
  end

  it "long_query" do
    resp   = QuasarRestClient.long_query(sql_fetch, new_collection_path, var: config.vars)
    expect(resp.code).to(eq(200), show_response(resp))
  end

  it "get_data" do
    QuasarRestClient.long_query(sql_fetch, new_collection_path, var: config.vars)
    resp    = QuasarRestClient.get_data(new_collection_path, limit: 2)
    expect(resp.code).to(eq(200), show_response(resp))
  end

  it "delete_data" do
    QuasarRestClient.long_query(sql_fetch, new_collection_path, var: config.vars)
    resp    = QuasarRestClient.delete_data(new_collection_path, limit: 2)
    expect(resp.code).to(eq(204), show_response(resp))
  end

end
