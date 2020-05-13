require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rake/extensiontask"

task :build => :compile

Rake::ExtensionTask.new("erptool") do |ext|
  ext.lib_dir = "lib/erptool"
end

task :default => [:clobber, :compile, :spec]
