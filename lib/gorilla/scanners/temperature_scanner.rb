# encoding: utf-8

module Gorilla
  class TemperatureScanner < Scanner
    degrees = /°| ?deg(?:ree)?s? /
    rule :celsius,    /#{degrees}?([Cc](?:elsius)?)|℃/
    rule :fahrenheit, /#{degrees}?([Ff](?:ahrenheit)?)|℉/
  end
end
