require 'test_helper'

class VolumeScannerTest < Test::Unit::TestCase
  def test_should_parse_cups
    regex = Gorilla::VolumeScanner.rules[:cup].regexp
    units = %w(
      c cp cu cup
    )

    units.each do |unit|
      assert_match regex, unit
      assert_match regex, unit.capitalize
      assert_match regex, unit.pluralize
      assert_match regex, unit.capitalize.pluralize
    end
  end

  def test_should_parse_gallons
    regex = Gorilla::VolumeScanner.rules[:gallon].regexp
    units = %w(
      gal gallon galn gl gln
    )

    units.each do |unit|
      assert_match regex, unit
      assert_match regex, unit.capitalize
      assert_match regex, unit.pluralize
      assert_match regex, unit.capitalize.pluralize
    end

    %w(
      g glon
    ).each { |bad| assert_no_match regex, bad }
  end

  def test_should_parse_liters
    regex = Gorilla::VolumeScanner.rules[:liter].regexp
    units = %w(
      l liter litr litre lr lt ltr
    )

    units.each do |unit|
      assert_match regex, unit
      assert_match regex, unit.capitalize
      assert_match regex, unit.pluralize
      assert_match regex, unit.capitalize.pluralize
    end

    %w(
      lier lire lit lite
    ).each { |bad| assert_no_match regex, bad }
  end

  def test_should_parse_fluid_ounces
    regex = Gorilla::VolumeScanner.rules[:fluid_ounce].regexp
    units = %w(
      ounce oz
    )

    units.each do |unit|
      assert_match regex, unit
      assert_match regex, unit.capitalize
      assert_match regex, unit.pluralize
      assert_match regex, unit.capitalize.pluralize
    end

    %w(
      onc once one ounc
    ).each { |bad| assert_no_match regex, bad }
  end

  def test_should_parse_pints
    regex = Gorilla::VolumeScanner.rules[:pint].regexp
    units = %w(
      p pint pnt pt
    )

    units.each do |unit|
      assert_match regex, unit
      assert_match regex, unit.capitalize
      assert_match regex, unit.pluralize
      assert_match regex, unit.capitalize.pluralize
    end

    %w(
      pi pin
    ).each { |bad| assert_no_match regex, bad }
  end

  def test_should_parse_quarts
    regex = Gorilla::VolumeScanner.rules[:quart].regexp
    units = %w(
      qrt qt quart
    )

    units.each do |unit|
      assert_match regex, unit
      assert_match regex, unit.capitalize
      assert_match regex, unit.pluralize
      assert_match regex, unit.capitalize.pluralize
    end

    %w(
      qart qat qua quar qurt qut
    ).each { |bad| assert_no_match regex, bad }
  end

  def test_should_parse_tablespoons
    regex = Gorilla::VolumeScanner.rules[:tablespoon].regexp
    assert_match regex, "T"

    units = %w(
      tablesp tablespn tablespoon tablsp tb tbls tblsp tblspn tblspoon tbs tbsp
      tbspn tbspoon
    )

    units.each do |unit|
      assert_match regex, unit
      assert_match regex, unit.capitalize
      assert_match regex, unit.pluralize
      assert_match regex, unit.capitalize.pluralize
    end

    %w(
      t table tables tsp tspn tspoon
    ).each { |bad| assert_no_match regex, bad }
  end

  def test_should_parse_teaspoons
    regex = Gorilla::VolumeScanner.rules[:teaspoon].regexp
    assert_match regex, "t"

    units = %w(
      teasp teaspoon teaspn tsp
    )

    units.each do |unit|
      assert_match regex, unit
      assert_match regex, unit.capitalize
      assert_match regex, unit.pluralize
      assert_match regex, unit.capitalize.pluralize
    end

    %w(
      T
    ).each { |bad| assert_no_match regex, bad }
  end
end
