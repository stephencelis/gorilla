require 'gorilla/time'
require 'gorilla/scanner'

module Gorilla
  class TimeScanner < Scanner
    rule :second,     /[Ss](?:ec(?:ond)?#{s}?)?|S(?:EC(?:OND)?#{s.upcase}?)/
    rule :minute,     /[Mm](?:in(?:ute)?#{s}?)?|M(?:IN(?:UTE)?#{s.upcase}?)/
    rule :hour,       /[Hh](?:(?:ou)?r#{s}?)?|H(?:(?:OU)?R#{s.upcase}?)?/
    rule :day,        /[Dd](?:ay#{s}?)?|D(?:AY#{s.upcase}?)/
    rule :week,       /[Ww](?:ee)?k#{s}?|W(?:EE)?K#{s.upcase}?/
    rule :month,      /[Mm](?:o(?:n(?:th))?#{s}?)|M(?:O(?:N(?:TH))?#{s.upcase}?)/
    rule :year,       /[Yy](?:ea)?r#{s}?|Y(?:EA)?R#{s.upcase}?/
    rule :decade,     /[Dd]ecade#{s}?|DECADE#{s.upcase}?/
    rule :century,    /[Cc]entur(?:y|ies)|CENTUR(?:Y|IES)/
    rule :millennium, /[Mm]illeni(?:um|a)|MILLENI(?:UM|A)/

    rule :iso8601, /\bP(\d+Y)?(\d+W)?(\d+D)?T?(\d+H)?(\d+M)?([\d.]+S)?\b/ do |r|
      y = Time.new r.scanner[1].to_i, :year
      w = Time.new r.scanner[2].to_i, :week
      d = Time.new r.scanner[3].to_i, :day
      h = Time.new r.scanner[4].to_i, :hour
      m = Time.new r.scanner[5].to_i, :minute
      s = Time.new r.scanner[6].to_f, :second
      y + w + d + h + m + s
    end

    rule :delimited, /\d{1,2}(?::\d{2}){1,2}/ do |r|
      h, m, s = r.to_s.split ':'
      time  = Time.new(h, :hour) + Time.new(m, :minute)
      time += Time.new(s, :second) if s
      time
    end
  end
end
