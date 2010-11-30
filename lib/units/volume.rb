module Units
  class Volume < Base
    register :liter do
      baseline
      match /[Ll](?:i?t(?:er|re?)|t|r)?s?/
    end
    metric! :liter

    register :teaspoon do
      factor 0.00492892159, :liter
      match /(?:t|(?:[Tt](?:ea)?s(?:p(?:oo)?n?)?))s?/
    end

    register :tablespoon do
      factor 3, :teaspoon
      match /(?:T|(?:[Tt](?:bl?s?p?|a?b(?:le?)?(?:s(?:p(?:oo)?n?)))))s?/
    end

    register :fluid_ounce do
      factor 2, :tablespoon
      match /(?:[Ff]l(?:uid|\.)? )?[Oo](?:unce|z)s?/
      train :liquids
    end

    register :cup do
      factor 8, :fluid_ounce
      match /[Cc]u?p?s?/
    end

    register :pint do
      factor 2, :cup
      match /[Pp](?:(?:i?n)?t)?s?/
    end

    register :quart do
      factor 2, :pint
      match /[Qq](?:(?:ua)?r)?ts?/
    end

    register :gallon do
      factor 4, :quart
      match /[Gg](?:a?l(?:(?:lo)?n)?)s?/
    end
  end
end
