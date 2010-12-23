# require 'bigdecimal'

module Gorilla
  # The base unit class from which all inherit.
  class Unit
    # Maps metric prefixes to scale.
    METRIC_MAP = {
      :yotta => 1_000_000_000_000_000_000_000_000,
      :zetta => 1_000_000_000_000_000_000_000,
      :exa   => 1_000_000_000_000_000_000,
      :peta  => 1_000_000_000_000_000,
      :tera  => 1_000_000_000_000,
      :giga  => 1_000_000_000,
      :mega  => 1_000_000,
      :kilo  => 1_000,
      :hecto => 100,
      :deca  => 10,
      :deci  => Rational(1, 10),
      :centi => Rational(1, 100),
      :milli => Rational(1, 1_000),
      :micro => Rational(1, 1_000_000),
      :nano  => Rational(1, 1_000_000_000),
      :pico  => Rational(1, 1_000_000_000_000),
      :femto => Rational(1, 1_000_000_000_000_000),
      :atto  => Rational(1, 1_000_000_000_000_000_000),
      :zepto => Rational(1, 1_000_000_000_000_000_000_000),
      :yocto => Rational(1, 1_000_000_000_000_000_000_000_000)
    }

    class << self
      # The base unit of the class.
      attr_accessor :base_unit

      # Whether or not to pluralize a unit.
      attr_accessor :pluralize

      # Defines the base unit of the class.
      #
      # ==== Example
      #
      #   class Coolness < Gorilla::Unit
      #     base :Fonzie, :metric => true
      #   end
      def base name, options = {}
        self.base_unit = name
        unit name, Rational(1), options
      end

      # Defines a unit of the class.
      #
      # The rule can be a Numeric factor or Proc relative to another unit. An
      # optional hash of data can be appended to the rule and will be
      # accessible wherever that rule is yielded to a block.
      #
      # ==== Example
      #
      #   Gorilla::Weight.class_eval do
      #     unit :sun, 2 * (10 ** 30), :kilogram
      #   end
      #
      #   Gorilla::Temperature.class_eval do
      #     unit :Q, lambda { |t| t + 57 }, :celsius, :source => 'Zork'
      #   end
      def unit *args
        options = args.last.is_a?(Hash) ? args.pop : {}
        name, conversion, other = args

        if conversion.respond_to? :call
          (options[:rules] ||= {})[other] = conversion
        elsif other
          options[:factor] = Rational rules[other][:factor], conversion
        else
          options[:factor] = Rational conversion
        end

        rules[name] = options

        if options[:metric]
          METRIC_MAP.each_pair do |prefix, factor|
            subname = :"#{prefix}#{name}"
            unit subname, factor, name
            rules[subname][:metric] = true
          end
        end
      end

      # Returns the hash of rules for the current class.
      def rules
        Gorilla.units[name] ||= {}
      end

      private

      def inherited klass
        klass.pluralize = true
      end
    end

    # The unit amount (can be +nil+).
    attr_reader :amount

    # The unit name.
    attr_reader :unit

    # Instantiates a new unit for the class. Assumes the base unit if one is
    # defined.
    #
    # ==== Example
    #
    #   Gorilla::Unit.new 1          # => (1)
    #   Gorilla::Time.new 1          # => (1 second)
    #   Gorilla::Time.new 1, :minute # => (1 minute)
    def initialize amount, unit = self.class.base_unit
      if unit && self.class.rules[unit].nil?
        raise TypeError, "no such unit #{self.class.name}:#{unit}"
      elsif unit.nil? && !instance_of?(Unit)
        raise ArgumentError, "unit can't be nil for #{self.class.name}"
      end

      @amount, @unit = amount, unit
    end

    # Converts an instance to a new unit.
    #
    # ==== Example
    #
    #   Gorilla::Weight.new(1, :pound).convert_to(:ounce) # => (16 ounces)
    def convert_to other_unit
      return dup if unit == other_unit

      unless self.class.rules.key? other_unit
        raise TypeError, "no such unit #{self.class.name}:#{other_unit}"
      end

      if unit and rules = self.class.rules[unit][:rules]
        unless rules.key? other_unit
          raise TypeError, "can't convert to #{self.class.name}:#{other_unit}"
        end

        amount = rules[other_unit].call normalized_amount
      else
        amount = normalized_amount
      end

      new = self.class.new amount
      new.unit = other_unit
      new
    end

    # Returns whether a unit was defined as metric.
    #
    # ==== Example
    #
    #   class Coolness < Gorilla::Unit
    #     base :Fonzie, :metric => true
    #   end
    #   Coolness.new(1, :megaFonzie).metric? # => true
    def metric?
      unit and self.class.rules[unit][:metric] || false
    end

    # Normalizes and expands a unit into an array of units. Filters rules based
    # on provided options, and yields each unit to an optional block. If the
    # block returns +false+, the unit will be omitted.
    #
    # ==== Example
    #
    #    Gorilla::Weight.new(24, :ounce).expand
    #    # => [(1 pound), (8 ounces)]
    #
    #    # The block provided here is also the default for Gorilla::Time.
    #    Gorilla::Time.new(1000, :second).expand { |t|
    #      !t.metric? && t.unit != :minute || t.unit == :second
    #    }
    #    # => [(16 minutes), (40 seconds)]
    def expand options = {}
      rules = rules_for_options options
      return [self] if rules.empty?

      clone = self
      units = []
      rules.sort_by { |_, r| r[:factor] }.each do |rule|
        clone = clone.convert_to rule[0]
        next unless yield clone if block_given?
        amount = clone.truncate
        units << clone and break if clone.metric? && amount > 0
        units << self.class.new(amount, clone.unit) if amount > 0
        clone %= 1
      end

      units
    end

    # Normalizes a unit to the nearest whole number. Filters rules based on
    # provided options, and yields each unit to an optional block. If the block
    # returns +false+, the unit will be omitted.
    #
    # ==== Example
    #
    #   weight = Gorilla::Weight.new 0.021, :kilogram # => (0.021 kilograms)
    #   weight.normalize
    #   # => (21 grams)
    #
    #   weight.normalize { |w| w.metric? && w.amount >= 1 }
    #   # => (2.1 decagrams)
    def normalize options = {}
      rules = rules_for_options options
      return if rules.empty?

      rules.sort_by { |_, r| r[:factor] }.each do |rules|
        clone = convert_to rules[0]
        block_given? and case yield clone
          when true then return clone when false then next
        end
        return clone if clone.amount >= 1 && (clone % 1).round(10).zero?
      end

      self
    end

    def normalize! options = {}, &block
      normalized = normalize options, &block
      return if eql? normalized
      @amount, @unit = normalized.amount, normalized.unit
      self
    end

    def coerced_amount
      amount = metric? ? self.amount.to_f : self.amount.to_r
      amount = amount.to_f if amount.denominator > 100
      amount = amount.to_i if amount.denominator == 1
      amount
    end

    def humanized_amount
      return unless amount = coerced_amount

      if amount.is_a?(Rational) && amount.numerator > amount.denominator
        amount = "#{amount.floor} #{amount % 1}"
      else
        amount = "#{amount}"
      end

      amount = amount.split '.'
      amount[0].gsub! /(?!\.)(\d)(?=(\d{3})+(?!\d))/, '\1,'
      amount.join '.'
    end

    def humanized_unit
      return unless unit
      humanized = unit.to_s.gsub '_', ' '
      humanized << (humanized.end_with?('s') ? 'es' : 's') if pluralize?
      humanized
    end

    def to_s
      [humanized_amount, humanized_unit].compact.join(' ')
    end

    def inspect
      "(#{to_s})"
    end

    include Comparable

    def <=> other
      return unless self.class == other.class
      normalized_amount <=> other.normalized_amount
    end

    def == other
      return amount == other if instance_of? Unit
      self.class == other.class && normalized_amount == other.normalized_amount
    end

    def + other
      self.class.new amount + other.convert_to(unit).amount, unit
    end

    def - other
      self.class.new amount - other.convert_to(unit).amount, unit
    end

    def * other
      self.class.new amount * other, unit
    end

    def / other
      self.class.new amount / other, unit
    end

    def % other
      self.class.new amount % other, unit
    end
    alias modulo %

    def ** other
      self.class.new amount ** other, unit
    end
    alias power! **

    def abs
      self.class.new amount.abs, unit
    end
    alias magnitude abs

    def abs2
      self.class.new amount.abs2, unit
    end

    def ceil
      amount.ceil
    end

    def coerce other
      case other
      when Unit
        [other, convert_to(other.unit)]
      when Numeric
        [self.class.new(other, unit), self]
      else
        raise TypeError, "#{self.class} can't be coerced into #{other.class}"
      end
    end

    def denominator
      amount.denominator
    end

    def div n
      to_i.div n
    end

    def eql? other
      unit.eql?(other.unit) && normalized_amount.eql?(other.normalized_amount)
    end

    def even?
      amount.even?
    end

    def floor
      amount.floor
    end

    def finite?
      amount.finite?
    end

    def infinite?
      amount.infinite?
    end

    def integer?
      amount && coerced_amount.integer?
    end

    def nonzero?
      amount.zero?
    end

    def numerator
      amount.numerator
    end

    def odd?
      amount && amount.odd?
    end

    def real?
      amount && amount.real?
    end

    def round digits
      amount.round digits
    end

    def to_f
      amount.to_f
    end

    def to_i
      amount.to_i
    end
    alias to_int   to_i
    alias truncate to_i

    def to_r
      amount.to_r
    end

    def zero?
      amount.zero?
    end

    protected

    def unit= unit
      @unit = unit and @amount *= factor || 1
    end

    def normalized_amount
      factor ? Rational(amount, factor) : amount
    end

    private

    def factor
      return if instance_of? Unit
      self.class.rules[unit][:factor] if self.class.rules.key? unit
    end

    def rules_for_options options
      rules = self.class.rules.reject { |_, r| r[:factor].nil? }

      unless options.empty?
        rules.reject! { |_, r|
          options.none? { |k, v| r[k] == v || r[k].nil? && v == false }
        }
      end

      rules
    end

    def pluralize?
      return false unless self.class.pluralize

      case abs = coerced_amount.abs
        when Rational then abs <= 0 || abs > 1
        when Numeric  then abs != 1
        else               false
      end
    end

    def method_missing method_name, *args, &block
      if args.empty? && unit = method_name.to_s.sub!(/^to_/, '')
        if Gorilla.units.key? unit
          return convert_to unit
        elsif Gorilla.const_defined? :CoreExt
          return convert_to 1.send(unit).unit rescue super
        end
      end

      super
    end
  end
end
