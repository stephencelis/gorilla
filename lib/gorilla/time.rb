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
