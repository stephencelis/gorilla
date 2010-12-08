require 'rdoctest/task'

Rdoctest::Task.new do |t|
  t.ruby_opts << '-rgorilla/all -rgorilla/core_ext'
end

task :default => :doctest
