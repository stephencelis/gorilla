require 'units'
require 'units/all'
require 'minitest/autorun'

class TestUnits < MiniTest::Unit::TestCase
  def test_scanning
    expected = [
      Units::Weight.new(12, :pound),
      Units::Weight.new(2, :ounce)
    ]

    assert_equal expected, Units.scan('12lbs, 2 oz')
  end
end
