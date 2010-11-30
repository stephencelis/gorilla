require 'units/base'

module Units
  @units = {}

  class << self
    attr_reader :units
  end
end
