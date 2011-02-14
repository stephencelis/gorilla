require 'test_helper'

class WeightScannerTest < Test::Unit::TestCase
  def test_should_parse_grams
    regex = Gorilla::WeightScanner.rules[:gram].regexp
    units = %w(
      g gm gr gram
    )

    units.each do |unit|
      assert_match regex, unit
      assert_match regex, unit.capitalize
      assert_match regex, unit.pluralize
      assert_match regex, unit.capitalize.pluralize
    end

    %w(
      ga gra
    ).each { |bad| assert_no_match regex, bad }
  end

  def test_should_parse_ounces
    regex = Gorilla::WeightScanner.rules[:ounce].regexp
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

  def test_should_parse_pounds
    regex = Gorilla::WeightScanner.rules[:pound].regexp
    units = %w(
      lb pd pnd pound #
    )

    units.each do |unit|
      assert_match regex, unit
      assert_match regex, unit.capitalize
      assert_match regex, unit.pluralize
      assert_match regex, unit.capitalize.pluralize
    end

    %w(
      p pn
    ).each { |bad| assert_no_match regex, bad }
  end

  def test_should_not_mix_ranges
    assert_equal [10.oz, 150.g], Gorilla::WeightScanner.scan("10oz or 150g")
  end

  def test_should_fake_pluralize
    assert_equal "21 grams",
      Gorilla::WeightScanner.scrub("21 gram(s)") { |r| r.value }
  end
end
