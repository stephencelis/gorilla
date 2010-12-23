# encoding: utf-8
require 'test_helper'

class TemperatureScannerTest < Test::Unit::TestCase
  def test_should_parse_celsius
    regex = Gorilla::TemperatureScanner.rules[:celsius].regexp

    [
      '°C',
      'deg C',
      'degs C',
      'degrees C',
      'C',
      'Celsius',
      'celsius',
      '℃'
    ].each { |unit| assert_match regex, unit }

    %w(
      c
    ).each { |bad| assert_no_match regex, bad }
  end

  def test_should_parse_fahrenheit
    regex = Gorilla::TemperatureScanner.rules[:fahrenheit].regexp

    [
      '°F',
      'deg F',
      'degs F',
      'degrees F',
      'F',
      'Fahrenheit',
      'fahrenheit',
      '℉'
    ].each { |unit| assert_match regex, unit }

    %w(
      f
    ).each { |bad| assert_no_match regex, bad }
  end
end
