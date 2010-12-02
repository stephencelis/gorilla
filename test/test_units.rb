require 'gorilla'
require 'gorilla/all'
require 'gorilla/scanners'
require 'minitest/autorun'

class TestUnits < MiniTest::Unit::TestCase
  def test_scanning
    expected = [
      Gorilla::Weight.new(12, :pound),
      Gorilla::Weight.new(2, :ounce)
    ]

    assert_equal expected, Gorilla::WeightScanner.scan('12lbs, 2 oz')
  end
end
