require 'gorilla/unit'

module Gorilla
  @units = {}

  class << self
    attr_reader :units
  end
end

G = Gorilla
