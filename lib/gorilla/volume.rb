require 'gorilla'

module Gorilla
  class Volume < Unit
    base :liter, :metric => true

    unit :teaspoon,    0.00492892159, :liter
    unit :tablespoon,  3, :teaspoon
    unit :fluid_ounce, 2, :tablespoon
    unit :cup,         8, :fluid_ounce
    unit :pint,        2, :cup
    unit :quart,       2, :pint
    unit :gallon,      4, :quart
  end
end
