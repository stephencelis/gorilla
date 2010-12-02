module Gorilla
  class Weight < Unit
    base :gram, :metric => true

    unit :ounce, 28.3495231, :gram
    unit :pound, 16, :ounce
  end
end
