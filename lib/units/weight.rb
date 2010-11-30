module Units
  class Weight < Base
    register :gram do
      baseline
      match /[Gg](?:r(?:am)?|m)?s?/
    end
    metric! :gram

    register :ounce do
      factor 28.3495231, :gram
      match /[Oo](?:unce|z)s?/
      train :solids
    end

    register :pound do
      factor 16, :ounce
      match /(?:[Pp](?:ou)?n?d|[Ll]b|#)s?/
    end
  end
end
