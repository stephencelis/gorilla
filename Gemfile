source :rubygems

gemspec

group :test do
  gem 'minitest'
  gem 'autotest'

  if RUBY_PLATFORM =~ /darwin/
    gem 'autotest-growl'
    gem 'autotest-fsevent'
  end
end
