# encoding: utf-8
require 'gorilla'
require 'bigdecimal'

module Gorilla
  class Temperature < Unit
    base :celsius, :plural => false, :rules => {
      :fahrenheit => proc { |t| (t * Rational(9, 5)) + 32 },
      :kelvin => proc { |t| t - BigDecimal('273.15') }
    }
    unit :fahrenheit, proc { |t| (t - 32) * Rational(5, 9) }, :plural => false
    unit :kelvin, proc { |t| t + BigDecimal('273.15') }, :plural => false

    def humanized_amount
      return unless amount = coerced_amount
      "#{amount.is_a?(Rational) ? amount.to_f : amount}°"
    end

    def humanized_unit
      super.capitalize if unit
    end
  end
end
