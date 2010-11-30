module Units
  class Weight < Base
    base :gram, :metric => true

    unit :ounce, BigDecimal('28.3495231'), :gram
    unit :pound, 16, :ounce
  end
end
