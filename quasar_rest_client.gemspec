# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quasar_rest_client/version'

Gem::Specification.new do |spec|
  spec.name          = "quasar_rest_client"
  spec.version       = QuasarRestClient::VERSION
  spec.authors       = ["Tamara Temple"]
  spec.email         = ["tamara.temple@bluewaterbrand.com"]

  spec.summary       = %q{Wraps the Quasar RESTful API in a client library.}
  spec.homepage      = "https://github.com/riverock/quasar_rest_client"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "none"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.14"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"

end
