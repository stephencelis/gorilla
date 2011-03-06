require 'gorilla'

module Gorilla
  class Length < Unit
    base :meter, :metric => true

    unit :inch, 2.54, :centimeter
    unit :foot, 12, :inch, :plural => :feet
    unit :yard, 3, :foot
    unit :mile, 5_280, :foot

    unit :fathom, 2, :yard
    unit :nautical_mile, 1_852, :meter
  end
end
