require 'test_helper'

class TimeScannerTest < Test::Unit::TestCase
  def test_should_parse_seconds
    regex = Gorilla::TimeScanner.rules[:second].regexp
    durations = %w(
      s sec second seconds secs
    )

    durations.each do |duration|
      assert_match regex, duration
      assert_match regex, duration.capitalize
      assert_match regex, duration.upcase
    end

    %w(
      ss
    ).each { |bad| assert_no_match regex, bad }
  end

  def test_should_parse_minutes
    regex = Gorilla::TimeScanner.rules[:minute].regexp
    durations = %w(
      m min mins minute minutes
    )

    durations.each do |duration|
      assert_match regex, duration
      assert_match regex, duration.capitalize
      assert_match regex, duration.upcase
    end

    %w(
      ms
    ).each { |bad| assert_no_match regex, bad }
  end

  def test_should_parse_hours
    regex = Gorilla::TimeScanner.rules[:hour].regexp
    durations = %w(
      h hour hours hr hrs
    )

    durations.each do |duration|
      assert_match regex, duration
      assert_match regex, duration.capitalize
      assert_match regex, duration.upcase
    end

    %w(
      hs
    ).each { |bad| assert_no_match regex, bad }
  end

  def test_should_parse_days
    regex = Gorilla::TimeScanner.rules[:day].regexp
    durations = %w(
      d day days
    )

    durations.each do |duration|
      assert_match regex, duration
      assert_match regex, duration.capitalize
      assert_match regex, duration.upcase
    end

    %w(
      ds
    ).each { |bad| assert_no_match regex, bad }
  end

  def test_should_scan
    {
      ["1h30m",
       "1hr, 30min",
       "1 H 30 M"] => [1.hour, 30.minutes],
      ["1:30",
       "one hour and thirty minutes",
       # "hour plus thirty",
       "an hour and a half"] => [1.5.hours],
      ["2h20m",
       "2hr, 20min",
       "2 H 20 M"] => [2.hours, 20.minutes],
      [# "two hours and twenty",
       "2:20"] => [2.hours + 20.minutes],
      ["0 min", "zero min"] => [0.minutes],
      "one hundred and eighty-two minutes, fifteen seconds" =>
        [182.minutes, 15.seconds],
      "40 to 45 min" => [40.minutes..45.minutes],
      "between 18 and 22 hours" => [18.hours..22.hours],
      "Bake at 325 for 45 min" => [45.minutes],
      "Let dough rest 4.5 hours" => [4.5.hours],
      "Nineteen hundred minutes" => [1_900.minutes],
      "a half hour" => [0.5.hours],
      # "3 and a half hours" => [3.5.hours],
      # "3 hours and 15" => [3.hours, 15.minutes],
      "3 1/2 hours" => [3.5.hours],
      "half day" => [0.5.days],
      "another minute or two" => [1.minute..2.minutes],
      <<LONGER => [10.min, 8.min, 12.min, 22.min..25.min, 10.min]
Turn the oven on to 400 degrees. Meanwhile, chop onions and fry till
translucent, about 10 minutes. Add mushrooms and cook water out of them,
another 8 minutes. Boil until reduced (12 minutes). Put in oven and bake for
22 to 25 minutes till done. Let rest 10 minutes.
LONGER
    }.each do |inputs, parsed|
      [*inputs].each do |input|
        assert_equal parsed, Gorilla::TimeScanner.scan(input), input
      end
    end
  end

  def test_should_parse_iso8601
    {
      "P1Y2W3DT4H5M6.7S" =>
        1.year + 2.weeks + 3.days + 4.hours + 5.minutes + 6.7.seconds,
      "PT15M" => 15.minutes,
      "PT1H30M" => 1.5.hours,
      "P1DY3" => nil # Invalid.
    }.each do |input, parsed|
      assert_equal parsed, Gorilla::TimeScanner.parse(input), input
    end
  end
end
