module Gorilla::CoreExt
  def unit
    Gorilla::Base.new self
  end
  alias units unit

  Gorilla.units.each_pair do |klass_name, configs|
    configs.each_key do |unit|
      klass = Gorilla.const_get klass_name[/\w+$/]

      define_method unit do
        klass.new self, unit
      end
      alias_method "#{unit}s", unit if klass.pluralize
    end
  end

  alias Celsius celsius
  alias C celsius
  alias Fahrenheit fahrenheit
  alias F fahrenheit

  alias s second
  alias sec second
  alias ms millisecond
  alias min minute
  alias h hour
  alias hr hour
  alias d day

  alias litre liter
  alias l liter
  alias L liter
  alias millilitre milliliter
  alias ml milliliter
  alias mL milliliter
  alias centilitre centiliter
  alias cl centiliter
  alias cL centiliter
  alias t teaspoon
  alias tsp teaspoon
  alias T tablespoon
  alias tbs tablespoon
  alias tbsp tablespoon
  alias fl_oz fluid_ounce
  alias oz_fl fluid_ounce
  alias c cup
  alias cu cup
  alias pt pint
  alias qt quart
  alias gal gallon

  alias g gram
  alias kg kilogram
  alias mg milligram
  alias lb pound
  alias lbs pounds
  alias oz ounce
  alias ozs ounces
end

class Numeric
  include Gorilla::CoreExt
end
