# encoding: utf-8
require 'gorilla/temperature'
require 'gorilla/scanner'

module Gorilla
  class TemperatureScanner < Scanner
    degrees = /°|[ -]?deg(?:ree)?#{s}?/
    rule :celsius,    /(?:#{degrees} ?)?(?:C|[Cc]elsius)|℃/
    rule :fahrenheit, /(?:#{degrees} ?)?(?:F|[Ff]ahrenheit)|℉|#{degrees}/
  end
end
