class UnitsScanner < Units::Scanner
  rules.update TemperatureScanner.rules
  rules.update TimeScanner.rules
  rules.update VolumeScanner.rules
  rules.update WeightScanner.rules
end
