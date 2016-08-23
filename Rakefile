require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "update samples"
task :update_samples => %W[live-test.rb-sample]
rule ".rb-sample" => ".rb" do |t|
  sh "sed -e \"/^### BEGIN_SCRUB/,/^### END_SCRUB/s/'.*'/'-'/\" #{t.source} > #{t.name}"
end
