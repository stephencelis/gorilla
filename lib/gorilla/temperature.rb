# encoding: utf-8

module Gorilla
  class Temperature < Unit
    unit :celsius,    lambda { |t| Rational(9, 5) * (t + 32) }, :fahrenheit
    unit :fahrenheit, lambda { |t| Rational(5, 9) * (t - 32) }, :celsius

    self.pluralize = false

    def humanized_amount
      "#{super}°"
    end

    def humanized_unit
      super.capitalize if unit
    end
  end
end
