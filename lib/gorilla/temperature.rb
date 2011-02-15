# encoding: utf-8
require 'gorilla'

module Gorilla
  class Temperature < Unit
    unit :celsius,    lambda { |t| (t * Rational(9, 5)) + 32 }, :fahrenheit,
      :plural => false
    unit :fahrenheit, lambda { |t| (t - 32) * Rational(5, 9) }, :celsius,
      :plural => false

    def humanized_amount
      "#{super}°"
    end

    def humanized_unit
      super.capitalize if unit
    end
  end
end
