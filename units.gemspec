$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require 'units/version'

Gem::Specification.new do |s|
  s.date = "2010-11-23"

  s.name = "units"
  s.version = Units::Version::VERSION
  s.summary = "Units."
  s.description = "Units."

  s.files = Dir["README.rdoc", "Rakefile", "lib/**/*"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "classifier"
  s.add_dependency "gsl"
  s.add_dependency "madeleine"

  s.extra_rdoc_files = %w(README.rdoc)
  s.has_rdoc = true
  s.rdoc_options = %w(--main README.rdoc)

  s.author = "Stephen Celis"
  s.email = "stephen@stephencelis.com"
  s.homepage = "http://github.com/stephencelis/units"
end
