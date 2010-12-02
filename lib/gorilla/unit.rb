module Gorilla
  # The base unit class from which all inherit.
  class Unit
    # Maps metric prefixes to scale.
    #-
    # TODO: Uncomment when Scanner is ready.
    #+
    METRIC_MAP = {
      # :yotta => 1_000_000_000_000_000_000_000_000,
      # :zetta => 1_000_000_000_000_000_000_000,
      # :exa   => 1_000_000_000_000_000_000,
      # :peta  => 1_000_000_000_000_000,
      # :tera  => 1_000_000_000_000,
      # :giga  => 1_000_000_000,
      # :mega  => 1_000_000,
      :kilo  => 1_000,
      # :hecto => 100,
      # :deca  => 10,
      # :deci  => Rational(1, 10),
      :centi => Rational(1, 100),
      :milli => Rational(1, 1_000),
      # :micro => Rational(1, 1_000_000),
      # :nano  => Rational(1, 1_000_000_000),
      # :pico  => Rational(1, 1_000_000_000_000),
      # :femto => Rational(1, 1_000_000_000_000_000),
      # :atto  => Rational(1, 1_000_000_000_000_000_000),
      # :zepto => Rational(1, 1_000_000_000_000_000_000_000),
      # :yocto => Rational(1, 1_000_000_000_000_000_000_000_000)
    }

    class << self
      attr_accessor :pluralize

      def base name, options = {}
        unit name, Rational(1), options
      end

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

      def rules
        Gorilla.units[name] ||= {}
      end

      private

      def inherited klass
        klass.pluralize = true
      end
    end

    attr_reader :amount
    attr_reader :unit

    def initialize amount, unit = nil
      if instance_of?(Unit) && unit
        raise TypeError, "no such unit #{self.class.name}:#{unit}"
      end

      @amount, @unit = amount, unit
    end

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

    def unit= unit
      unless self.class.rules.key? unit
        raise TypeError, "no such unit #{self.class.name}:#{unit}"
      end

      @unit = unit and @amount *= factor || 1
    end

    include Comparable

    def <=> other
      unless self.class == other.class
        raise TypeError, "incompatible type #{other.class.name}"
      end

      normalized_amount <=> other.normalized_amount
    end

    def == other
      self.class == other.class && normalized_amount == other.normalized_amount
    end

    def + other
      new = self.class.new normalized_amount + other.normalized_amount
      new.unit = unit
      new
    end

    def - other
      new = self.class.new normalized_amount - other.normalized_amount
      new.unit = unit
      new
    end

    def +@
      self.class.new +amount, unit
    end

    def -@
      self.class.new -amount, unit
    end

    def % n
      self.class.new amount % n, unit
    end

    def ** n
      self.class.new amount ** n, unit
    end

    def * n
      self.class.new amount * n, unit
    end

    def / n
      self.class.new amount / n, unit
    end

    def abs
      self.class.new amount.abs, unit
    end

    def metric?
      unit and self.class.rules[unit][:metric] || false
    end

    def expand
      rules = self.class.rules.reject { |_, r| r[:factor].nil? }
      return [self] if rules.empty?

      clone = self
      units = []
      rules.sort_by { |_, r| r[:factor] }.each do |rule|
        clone = clone.convert_to rule[0]
        amount = clone.amount.to_i
        units << clone and break if clone.metric? && amount > 0
        units << self.class.new(amount, clone.unit) if amount > 0
        clone %= 1
      end

      units
    end

    def normalize
      rules = self.class.rules.reject { |_, r| r[:factor].nil? }
      return if rules.empty?

      clone = self
      rules.sort_by { |_, r| r[:factor] }.each do |rules|
        clone = clone.convert_to rules[0]
        amount = clone.amount
        return clone if (amount % 1).zero? || (clone.metric? && amount >= 1)
      end
    end

    def coerced_amount
      amount = metric? ? self.amount.to_f : self.amount.to_r

      if amount.denominator == 1
        amount = amount.to_i
      elsif amount.denominator > 100
        amount = amount.to_f
      end

      amount
    end

    def humanized_amount
      return unless amount
      amount = coerced_amount

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

    protected

    def normalized_amount
      factor ? Rational(amount, factor) : amount
    end

    private

    def factor
      return if instance_of? Unit
      self.class.rules[unit][:factor] if self.class.rules.key? unit
    end

    def pluralize?
      return false unless self.class.pluralize

      case abs = coerced_amount.abs
      when Rational
        abs <= 0 || abs > 1
      when Numeric
        abs != 1
      else
        false
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
