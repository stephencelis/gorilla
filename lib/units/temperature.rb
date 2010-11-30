# encoding: utf-8
module Units
  class Temperature < Base
    self.pluralize = false

    DEGREES = /°| ?deg(?:ree)?s? /

    register :celsius do
      rule(:fahrenheit) { |t| Rational(9, 5) * (t + 32) }
      match /#{DEGREES}?([Cc](?:elsius)?)|℃/
    end

    register :fahrenheit do
      rule(:celsius) { |t| Rational(5, 9) * (t - 32) }
      match /#{DEGREES}?([Ff](?:ahrenheit)?)|℉/
    end

    def humanized_amount
      "#{super}°"
    end

    def humanized_unit
      super.capitalize
    end
  end
end
