require "httparty"

module QuasarRestClient
  class Proxy
    include HTTParty

    # @!attribute query_hash
    #   @return [Hash] values to form the query string for the request
    attr_accessor :query_hash

    # Set up the proxy object
    #
    # @param [String] q -- the SQL^2 query string passed in WITHOUT encoding
    # @param [Hash] opts -- options to pass along to the Quasar request
    # @option opts [Integer] :limit -- limit to the number of records retrieved
    # @option opts [Integer] :offset -- starting record
    # @option opts [Hash] :var -- variable substitutions for parametric queries
    #
    # @example
    # For the last option, `:var`, the hash keys match the variable name used in
    # the query string. For example, given a query string of:
    #
    #     SELECT * WHERE pop < :cutoff
    #
    # @example
    #
    # The var hash should have:
    #
    #     { cutoff: 100 }
    #
    # To set the value of the cutoff.
    #
    def initialize(q='', opts={})
      self.query_hash = Hash.new
      self.query_hash[:q] = q
      self.query_hash.merge!(opts)
    end

    # @return [String] JSON response from query
    def simple_query
      self.class.get(
        path,
        query: request_query,
        headers: request_headers,
        logger: Base.config.logger,
        base_uri: Base.config.endpoint
        )
    end

    private

    def endpoint
      Base.config.endpoint
    end

    # TODO: return proper path based on query type for future expansion
    def path
      '/query/fs'
    end

    def request_headers
      {
        "accept-encoding" => '',
        "accept" => "application/json"
      }
    end

    def request_query
      stringify_keys(query_hash)
    end

    def stringify_keys(hash)
      hash.map do |k,v|
        [k.to_s, v]
      end.to_h
    end
  end
end
