require 'gorilla/length'
require 'gorilla/scanner'

module Gorilla
  class LengthScanner < Scanner
    rule :meter, /[Mm](?:eter#{s}?)?/
    rule :inch,  /[Ii]n(?:ch#{es}?)?|(?<=\d)"/
    rule :foot,  /[Ff](?:oo|ee)?t|(?<=\d)'/
    rule :yard,  /[Yy](?:ar)?d#{s}?/
    rule :mile,  /[Mm]i(?:le#{s}?)?/
  end
end
