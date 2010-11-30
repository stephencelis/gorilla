begin
  require 'scantron'
  require 'number_scanner'
  require 'range_scanner'
  require 'units/scanner'
  require 'units/scanners/temperature_scanner'
  require 'units/scanners/time_scanner'
  require 'units/scanners/volume_scanner'
  require 'units/scanners/weight_scanner'
  require 'units/scanners/units_scanner'
rescue LoadError
  abort "Missing required 'scantron' gem!"
end
