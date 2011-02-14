require 'test_helper'

class LengthScannerTest < Test::Unit::TestCase
  def test_should_parse_meters
    regex = Gorilla::LengthScanner.rules[:meter].regexp
    units = %w(
      m meter meters
    )

    units.each do |unit|
      assert_match regex, unit
      assert_match regex, unit.capitalize
    end

    %w(
      ms
    ).each { |bad| assert_no_match regex, bad }
  end

  def test_should_parse_inches
    regex = Gorilla::LengthScanner.rules[:inch].regexp
    units = %w(
      in inch inches 6"
    )

    units.each do |unit|
      assert_match regex, unit
      assert_match regex, unit.capitalize
    end

    %w(
      "
    ).each { |bad| assert_no_match regex, bad }
  end

  def test_should_parse_feet
    regex = Gorilla::LengthScanner.rules[:foot].regexp
    units = %w(
      ft foot feet 6'
    )

    units.each do |unit|
      assert_match regex, unit
      assert_match regex, unit.capitalize
    end

    %w(
      '
    ).each { |bad| assert_no_match regex, bad }
  end

  def test_should_parse_yards
    regex = Gorilla::LengthScanner.rules[:yard].regexp
    units = %w(
      yd yard
    )

    units.each do |unit|
      assert_match regex, unit
      assert_match regex, unit.pluralize
      assert_match regex, unit.capitalize
      assert_match regex, unit.capitalize.pluralize
    end

    %w(
      y yr
    ).each { |bad| assert_no_match regex, bad }
  end

  def test_should_parse_miles
    regex = Gorilla::LengthScanner.rules[:mile].regexp
    units = %w(
      mi mile miles
    )

    units.each do |unit|
      assert_match regex, unit
      assert_match regex, unit.capitalize
    end

    %w(
      m
    ).each { |bad| assert_no_match regex, bad }
  end
end
