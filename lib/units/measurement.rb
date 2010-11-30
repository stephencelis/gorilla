module Units
  class Measurement
    NUMBER_MAP = {
      'zero'      => 0,
      'one'       => 1,
      'two'       => 2,
      'three'     => 3,
      'four'      => 4,
      'five'      => 5,
      'six'       => 6,
      'seven'     => 7,
      'eight'     => 8,
      'nine'      => 9,
      'ten'       => 10,
      'eleven'    => 11,
      'twelve'    => 12,
      'thirteen'  => 13,
      'fourteen'  => 14,
      'fifteen'   => 15,
      'sixteen'   => 16,
      'seventeen' => 17,
      'eighteen'  => 18,
      'nineteen'  => 19,
      'twenty'    => 20,
      'thirty'    => 30,
      'forty'     => 40,
      'fifty'     => 50,
      'sixty'     => 60,
      'seventy'   => 70,
      'eighty'    => 80,
      'ninety'    => 90,
      'hundred'   => 100
    }

    NUMBER = %r{\d*\s*
      #{NUMBER_MAP.keys.map { |v| %r{\b#{v}\b[ -]?}i }.reverse.join '|'}+|(?:
        (?:\d+\s)?(?:\d+/\d+)(?!\.) (?# Match fractions/rationals. )
        |\d+\.\d+                   (?# Match decimals. )
        |\d+(?!\.\d*)               (?# Match numerals. )
      )(?![[:punct:]]\D)?
    }x

    NUMBER_RANGE = /(?:#{NUMBER}+(?: (?:and|to) | ?- ?))?#{NUMBER}+/
  end
end
