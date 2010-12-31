require 'test_helper'

class TimeTest < Test::Unit::TestCase
  def test_should_format_iso8601
    {
      1.5.minutes => "PT1M30S",
      45.minutes => "PT45M",
      90.minutes => "PT1H30M",
      1.5.days => "P1DT12H"
    }.each_pair do |duration, iso8601|
      assert_equal iso8601, duration.iso8601
    end
  end
end
