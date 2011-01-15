require 'gorilla/scanner'
require 'gorilla/time'

module Gorilla
  class TimeScanner < Scanner
    rule :second,     /[Ss](?:ec(?:ond)?s?)?|S(?:EC(?:OND)?S?)/
    rule :minute,     /[Mm](?:in(?:ute)?s?)?|M(?:IN(?:UTE)?S?)/
    rule :hour,       /[Hh](?:(?:ou)?rs?)?|H(?:(?:OU)?RS?)?/
    rule :day,        /[Dd](?:ays?)?|D(?:AYS?)/
    rule :week,       /[Ww](?:ee)?ks?|W(?:EE)?KS?/
    rule :month,      /[Mm](?:o(?:n(?:th))?s?)|M(?:O(?:N(?:TH))?S?)/
    rule :year,       /[Yy](?:ea)?rs?|Y(?:EA)?RS?/
    rule :decade,     /[Dd]ecades?|DECADES?/
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
