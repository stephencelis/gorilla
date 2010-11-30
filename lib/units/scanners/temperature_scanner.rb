# encoding: utf-8
class TemperatureScanner < Units::Scanner
  degrees = /°| ?deg(?:ree)?s? /
  rule :celsius,    /#{degrees}?([Cc](?:elsius)?)|℃/
  rule :fahrenheit, /#{degrees}?([Ff](?:ahrenheit)?)|℉/
end
