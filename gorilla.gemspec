$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require 'gorilla/version'

Gem::Specification.new do |s|
  s.date = "2011-01-15"

  s.name = "gorilla"
  s.version = Gorilla::Version::VERSION.dup
  s.summary = "Big, strong, intelligent, and gentle unit conversions."
  s.description = "A unit conversion and parsing library."

  s.files = Dir["README.rdoc", "Rakefile", "lib/**/*"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "scantron", "~> 0.0.1.beta"
  s.add_development_dependency "rdoctest", "~> 0.0.1"

  s.extra_rdoc_files = %w(README.rdoc)
  s.has_rdoc = true
  s.rdoc_options = %w(--main README.rdoc)

  s.author = "Stephen Celis"
  s.email = "stephen@stephencelis.com"
  s.homepage = "http://github.com/stephencelis/gorilla"
end
