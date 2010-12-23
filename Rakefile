require 'rake/testtask'
require 'rdoctest/task'

Rdoctest::Task.new do |t|
  t.ruby_opts << '-rgorilla/all -rgorilla/core_ext'
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
end

task :default => [:doctest, :test]
