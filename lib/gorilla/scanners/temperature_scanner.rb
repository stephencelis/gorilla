# encoding: utf-8
require 'gorilla/temperature'
require 'gorilla/scanner'

module Gorilla
  class TemperatureScanner < Scanner
    degrees = /°|[ -]?deg(?:ree)?#{s}?/

    celsius    = "(?:#{degrees} ?)?(?:C|[Cc]elsius)|℃"
    fahrenheit = "(?:#{degrees} ?)?(?:F|[Ff]ahrenheit)|℉|#{degrees}"

    if RUBY_VERSION >= '1.9'
      celsius.force_encoding 'ASCII-8BIT'
      fahrenheit.force_encoding 'ASCII-8BIT'
    end

    rule :celsius,    Regexp.new(celsius)
    rule :fahrenheit, Regexp.new(fahrenheit)
  end
end
