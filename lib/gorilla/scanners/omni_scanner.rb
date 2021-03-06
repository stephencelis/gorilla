# encoding: utf-8
require 'gorilla/scanner'
require 'gorilla/scanners/temperature_scanner'
require 'gorilla/scanners/time_scanner'
require 'gorilla/scanners/volume_scanner'
require 'gorilla/scanners/weight_scanner'

module Gorilla
  # An all-purpose units scanner combining the rules of TemperatureScanner,
  # TimeScanner, VolumeScanner, and WeightScanner.
  #
  #   Gorilla::OmniScanner.
  #     scan "Add 1 cup flour (125g). Bake @ 350F for 25 min."
  #   # => [(1 cup), (125 grams), (350° Fahrenheit), (25 minutes)]
  class OmniScanner < Scanner
    rules.update TemperatureScanner.rules
    rules.update TimeScanner.rules
    rules.update VolumeScanner.rules
    rules.update WeightScanner.rules
  end
end
