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

    rule :delimited,  /\d{1,2}(?::\d{2}){1,2}/ do |r|
      h, m, s = r.to_s.split ':'
      time  = Time.new(h, :hour) + Time.new(m, :minute)
      time += Time.new(s, :second) if s
      time
    end
  end
end
