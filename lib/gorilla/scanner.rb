# encoding: utf-8
require 'scantron'
require 'range_scanner'
require 'number_scanner'

module Gorilla
  # A {Scantron}[http://github.com/stephencelis/scantron] scanner class from
  # which all Gorilla::Scanner classes inherit.
  #
  # Your own Gorilla::Scanners will inherit the data assigned their
  # Gorilla::Unit definitions so that, for example, units defined as metric
  # will have additional scanner rules created for each prefix.
  #
  # For more information, see Gorilla::Scanner.rule.
  class Scanner < ::Scantron::Scanner
    # Maps metric prefixes to regular expressions used for parsing.
    METRIC_MAP = {
      # :yotta => /Y/,
      # :zetta => /Z/,
      # :exa   => /E/,
      # :peta  => /P/,
      # :tera  => /T/,
      # :giga  => /G/,
      # :mega  => /M/,
      :kilo  => /k(?:ilo)?/,
      # :hecto => /H/,
      # :deca  => /da/,
      # :deci  => /d/,
      :centi => /c(?:enti)?/,
      :milli => /m(?:illi)?/
      # :micro => /μ/,
      # :nano  => /n/,
      # :pico  => /p/,
      # :femto => /f/,
      # :atto  => /a/,
      # :zepto => /z/,
      # :yocto => /y/
    }

    @default = lambda { |r|
      pre_match = r.scanner.pre_match

      range = RangeScanner.new(pre_match).perform.last
      number = NumberScanner.new(pre_match).perform.last

      if range && number
        result = range.pos[1] >= number.pos[1] ? range : number
      else
        result = range || number
      end

      amount = result.value if result
      case amount
      when Range
        unit_class = constantize r.rule.data[:class_name]
        unit_class.new(amount.min, r.name)..unit_class.new(amount.max, r.name)
      else
        constantize(r.rule.data[:class_name]).new amount, r.name
      end
    }

    class << self
      # ==== Options
      #
      # [<tt>:class_name</tt>]  The Gorilla::Unit return class for the rule
      #                         given. By default, it is inferred from the name
      #                         of the scanner, so that a "BogosityScanner"
      #                         would try instantiate matches as "Bogosity"
      #                         units.
      #
      # [<tt>:metric</tt>]      Whether or not additional rules should be
      #                         generated for metric prefixes. By default, it
      #                         is inferred from the unit's original
      #                         definition.
      #
      # ==== Example
      #
      # Here we define a metric unit and scanner rule:
      #
      #   class Beauty < Gorilla::Unit
      #     base :Helen, :metric => true
      #   end
      #
      # And here we define the scanner rule:
      #
      #   class BeautyScanner < Gorilla::Scanner
      #     rule :Helen, /[Hh](?:elen)?s?/
      #   end
      #
      #   BeautyScanner.scan '1 milliHelen is required to launch the ship.'
      #   # => [(1 milliHelen)]
      #
      #   BeautyScanner.scan '2 kiloHelens'
      #   # => [(2 kiloHelens)]
      #
      # The return class (Beauty) is inferred from the scanner's class name
      # (less "Scanner"), and the metric setting is taken from the matching
      # rule on that class, but both can be overridden or made explicit.
      #
      #   class BeautyScanner < Gorilla::Scanner
      #     rule :Helen, /[Hh](?:elen)?s?/, :class_name => 'Beauty',
      #                                     :metric     => true
      #   end
      def rule unit, regexp, data = {}, &block
        if class_name = data.delete(:class_name)
          klass = constantize class_name
        elsif class_name = name.sub!(/Scanner$/, '')
          klass = constantize class_name rescue nil
        end

        config = { :class_name => class_name || 'Unit' }
        config.update klass.rules[unit] if klass && klass.rules[unit]
        config.update data

        super unit, /(?<=^|[\d ])#{regexp}\b/, config, &block

        if config[:metric]
          METRIC_MAP.each_pair do |pre, sub|
            super :"#{pre}#{unit}", /\b#{sub}#{regexp}\b/, config, &block
          end
        end
      end

      private

      def constantize class_name
        names = class_name.split("::")
        names.shift if names.first && names.first.empty?

        constant = Object
        names.each do |name|
          constant = if constant.const_defined?(name)
            constant.const_get name
          else
            constant.const_missing name
          end
        end
        constant
      end
    end
  end
end
