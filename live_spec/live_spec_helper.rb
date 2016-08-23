$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'quasar_rest_client'

RSpec.configure do |config|
  config.before(:example) do
    QuasarRestClient::Base.class_variable_set(:@@config, nil)
  end
end
