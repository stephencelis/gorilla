require 'gorilla'

module Gorilla
  class Time < Unit
    base :second, :metric => true

    unit :minute,     60, :second
    unit :hour,       60, :minute
    unit :day,        24, :hour
    unit :week,        7, :day
    unit :month,      30, :day
    unit :year,       52, :week
    unit :decade,     10, :year
    unit :century,    10, :decade
    unit :millennium, 10, :century

    # Expands in favor of non-metric units first. This behavior can be
    # overridden by providing a block, and negated if the block returns +true+.
    #
    # ==== Example
    #
    #   time = Gorilla::Time.new 1000, :second
    #   time.expand
    #   # => [(16 minutes), (40 seconds)]
    #
    #   time.expand(:metric => true) { true }
    #   # => [(1 kilosecond)]
    def expand options = {}, &block
      block ||= lambda { |t| !t.metric? || t.unit == :second }
      super options, &block
    end

    # Returns a string which represents the duration as defined by ISO 8601.
    #
    #   time = 1.year + 2.weeks + 3.days + 4.hours + 5.minutes + 6.5.seconds
    #   time.iso8601
    #   # => "P1Y2W3DT4H5M6.5S"
    def iso8601
      string = 'P'
      day = self.class.new 1, :day

      expand.each do |measured|
        string << 'T' if !string.include?('T') && measured < day
        string << measured.humanized_amount
        string << measured.unit.to_s[0, 1].capitalize
      end

      string
    end
  end
end
