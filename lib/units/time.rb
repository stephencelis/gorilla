module Units
  class Time < Base
    register :second do
      baseline
      match /[Ss](?:ec(?:ond)?s?)?|S(?:EC(?:OND)?S?)/
    end
    metric! :second, :milli

    register :minute do
      factor 60, :second
      match /[Mm](?:in(?:ute)?s?)|M(?:IN(?:UTE)?S?)/
    end

    register :hour do
      factor 60, :minute
      match /[Hh](?:(?:ou)?r)?s?|H(?:(?:OU)?R)?S?/
    end

    register :day do
      factor 24, :hour
      match /[Dd](?:ays?)?|D(?:AYS?)/
    end

    register :week do
      factor 7, :day
      match /[Ww](?:ee)?ks?|W(?:EE)?KS?/
    end

    register :month do
      factor 30, :day
      match /[Mm](?:o(?:n(?:th))?s?)|M(?:O(?:N(?:TH))?S?)/
    end

    register :year do
      factor 52, :week
      match /[Yy](?:ea)?rs?|Y(?:EA)?RS?/
    end

    register :decade do
      factor 10, :year
    end

    register :century do
      factor 10, :decade
    end

    register :millenium do
      factor 10, :century
    end

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
