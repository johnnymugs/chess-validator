require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
RSpec::Core::RakeTask.new(:basic) do |t|
  t.rspec_opts = '--tag ~integration'
end

task default: :spec

desc 'Start IRB with library loaded'
task :console do
  sh "irb -r ./validator.rb"
end

