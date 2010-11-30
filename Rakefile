require 'rake/testtask'

desc 'Default: run units units.'
task :default => :test

desc 'Run units units.'
Rake::TestTask.new :test do |t|
  t.libs << 'test'
  t.pattern = 'test/**/test_*.rb'
end
