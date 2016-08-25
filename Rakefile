require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

RSpec::Core::RakeTask.new(:live_spec) do |c|
  c.pattern = 'live_spec/**{,/*/**}/*_spec.rb'
  c.rspec_opts = '-I live_spec'
end
