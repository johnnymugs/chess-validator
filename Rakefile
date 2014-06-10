require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

task :console do
  sh "irb -r ./validator.rb"
end

