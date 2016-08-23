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

    # @return [String] JSON response from get query
    def simple_query
      self.class.get(
        '/query/fs',
        query: request_query,
        headers: request_headers,
        logger: Base.config.logger,
        base_uri: Base.config.endpoint
        )
    end

    # @param [String] destination collection name to create for later extraction
    # @return [String] JSON response from post query
    def long_query(destination:)
      fail "must provide a destination: #{destination.inspect} #{destination.class}" unless (String === destination && destination.length > 0)
      body = query_hash.delete(:q)
      self.class.post(
        '/query/fs',
        query: request_query,
        body: body,
        headers: request_headers.merge({"destination" => destination}),
        logger: Base.config.logger,
        base_uri: Base.config.endpoint
        )
    end

    # @param [String] collection name of the collection to retrieve
    # @return [String] JSON response
    def get_data(collection:)
      fail "must provide a collection: #{collection.inspect} [#{collection.class}]" unless (String === collection && collection.length > 0)

      unless collection[0] == ?/
        collection = ?/ + collection
      end

      query_hash.delete(:q)

      self.class.get(
        '/data/fs' + collection,
        query: request_query,
        headers: request_headers,
        logger: Base.config.logger,
        base_uri: Base.config.endpoint
        )
    end

    # @param [String] collection name of the collection to delete
    # @return [String] JSON response
    def delete_data(collection:)
      fail "must provide a collection: #{collection.inspect} [#{collection.class}]" unless (String === collection && collection.length > 0)

      unless collection[0] == ?/
        collection = ?/ + collection
      end

      self.class.delete(
        '/data/fs' + collection,
        headers: request_headers,
        logger: Base.config.logger,
        base_uri: Base.config.endpoint
        )
    end

    private

    def endpoint
      Base.config.endpoint
    end

    def mogrify_vars(hash)
      vars = hash[:var]&.map do |k, v|
        new_key = "var.#{k}"

        # This is hacky-hack, at best
        # E.g. given var: { email: "yacht@mail.com"} =>
        #            var.email: '"yacht@mail.com"'
        # i.e. quasar requires the double quotes
        # Note that the documentation says single quotes, but it is WRONG
        new_val = case v
                  when String
                    v.inspect
                  when Time
                    "TIME '#{v.strftime("%T")}'"
                  when Date
                    "DATE '#{v.strftime("%F")}'"
                  when Array
                    v.inspect
                  else
                    v
                  end

        [new_key, new_val]
      end.to_h

      hash.delete(:var)
      hash.merge(vars)
    end

    def request_headers
      {
        "accept-encoding" => '',
        "accept" => "application/json"
      }
    end

    def request_query
      stringify_keys(mogrify_vars(query_hash))
    end

    def stringify_keys(hash)
      hash.map do |k,v|
        [k.to_s, v]
      end.to_h
    end
  end
end
