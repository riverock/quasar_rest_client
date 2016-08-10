# coding: utf-8
require "quasar_rest_client/version"
require "quasar_rest_client/base"
require "quasar_rest_client/config"
require "quasar_rest_client/proxy"

# A small library to provide basic interaction with the
# [Quasar Rest API](http://quasar-analytics.org/docs/restapi/).
#
# Copyright © 2016 Bluewater, LLC.
#
# MIT License
#

module QuasarRestClient

  # Provide block-style configuration:
  #
  #     QuasarRestClient.configure do |config|
  #       config.endpoint = 'http://example.com'
  #     end
  def self.configure
    yield Base.config
  end

  # Access the configuration to set and retrieve information
  #
  #     QuasarRestClient.config.endpoint # => returns value
  #     QuasarRestClient.config.endpoint = 'https://example.com' # => sets endpoint
  #
  def self.config
    return Base.config
  end

  # Call Quasar with a simple query
  #
  # @param [String] q -- the SQL^2 query string passed in WITHOUT encoding
  # @param [Hash] opts -- options to pass along to the Quasar request
  # @option [Integer] :limit -- limit to the number of records retrieved
  # @option [Integer] :offset -- starting record
  # @option [Hash] :var -- variable substitutions for parametric queries
  #
  # For the last option, :var, the hash keys match the variable name used in
  # the query string. For example, given a query string of:
  #
  #     SELECT * WHERE pop < :cutoff
  #
  # The var hash should have:
  #
  #     { cutoff: 100 }
  #
  # To set the value of the cutoff.
  #
  #
  # Example:
  # --------
  #
  #     QuasarRestClient.simple_query(
  #       'SELECT * WHERE pop < :cutoff',
  #       {
  #         limit: 10,
  #         offset: 20,
  #         var: {
  #           cutoff: 100
  #         }
  #       }
  #     )
  #
  def self.simple_query(q='', opts={})
    proxy = Proxy.new(q, opts)
    proxy.simple_query
  end

end
