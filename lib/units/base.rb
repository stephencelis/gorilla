require 'bigdecimal'
require 'units/registration'

module Units
  class Base
    class << self
      attr_accessor :pluralize

      def register unit, &block
        Units::Registration.new(unit, self, &block).register
      end

      def metric! unit, *units
        konfig = config
        konfig[unit][:metric] = true

        { :milli => [Rational(1, 1_000), /m(?:illi)?/],
          :centi => [Rational(1, 100),   /c(?:enti)?/],
          :kilo  => [1_000,              /k(?:ilo)?/ ]
        }.each_pair do |prefix, (prefix_factor, prefix_matcher)|
          next unless units.empty? || units.include?(prefix)
          sub_unit = :"#{prefix}#{unit}"
          register sub_unit do
            factor prefix_factor, unit
            match /#{prefix_matcher}#{konfig[unit][:matcher]}/
          end
          konfig[sub_unit][:metric] = true
        end
      end

      def config
        Units.units[name]
      end

      private

      def inherited klass
        klass.pluralize = true
      end
    end

    attr_reader :amount
    attr_reader :unit

    # FIXME.
    attr_reader :pos

    def initialize amount, unit = nil, options = {}
      @amount = BigDecimal amount.to_s
      @unit = unit

      # FIXME.
      @pos = options[:pos]
    end

    def convert_to other_unit
      return dup if unit == other_unit

      unless self.class.config.key? other_unit
        raise TypeError, "no such unit #{self.class.name}:#{other_unit}"
      end

      if rules = self.class.config[unit][:rules]
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
      unless self.class.config.key? unit
        raise TypeError, "no such unit #{self.class.name}:#{unit}"
      end

      @unit = unit and @amount *= factor
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
      self.class.config[unit][:metric] || false
    end

    def expand
      rules = self.class.config.reject { |_, c| c[:factor].nil? }
      return [self] if rules.empty?

      clone = self
      units = []
      rules.sort_by { |_, c| c[:factor] }.each do |config|
        clone = clone.convert_to config[0]
        amount = clone.amount.to_i
        units << clone and break if clone.metric? && amount > 0
        units << self.class.new(amount, clone.unit) if amount > 0
        clone %= 1
      end

      units
    end

    def normalize
      rules = self.class.config.reject { |_, c| c[:factor].nil? }
      return if rules.empty?

      clone = self
      rules.sort_by { |_, c| c[:factor] }.each do |config|
        clone = clone.convert_to config[0]
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
      return if instance_of? Base
      self.class.config[unit][:factor] if self.class.config.key? unit
    end

    def pluralize?
      return false unless self.class.pluralize

      case abs = coerced_amount.abs
      when Rational, BigDecimal
        abs <= 0 || abs > 1
      when Numeric
        abs != 1
      else
        false
      end
    end

    def method_missing method_name, *args, &block
      if args.empty? && unit = method_name.to_s.sub!(/^to_/, '')
        if Units.units.key? unit
          return convert_to unit
        elsif Units.const_defined? :CoreExt
          return convert_to 1.send(unit).unit rescue super
        end
      end

      super
    end
  end
end
