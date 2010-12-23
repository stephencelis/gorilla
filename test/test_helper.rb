require 'test/unit'
require 'gorilla/all'
require 'gorilla/scanners'
require 'gorilla/core_ext'

class String
  def pluralize
    end_with?('s') ? to_s : "#{to_s}s"
  end
end
