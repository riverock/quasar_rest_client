module QuasarRestClient
  class Base
    def self.config
      return @@config ||= Config.new
    end
  end
end
