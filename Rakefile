begin
  require 'rdoctest/task'

  Rdoctest::Task.new do |t|
    t.ruby_opts << '-rgorilla/all -rgorilla/core_ext'
  end
  task :default => :doctest
rescue LoadError
end

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.warning = true
end

task :default => :test
