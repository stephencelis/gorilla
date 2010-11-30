module Units
  class Registration
    # Raised when a problem halts the registration process.
    class Error < StandardError
    end

    METRIC_MAP = {
      :milli => Rational(1, 1_000),
      :centi => Rational(1, 100),
      :kilo  => 1_000
    }

    def initialize unit, klass, &block
      @unit, @klass, @block = unit.to_sym, klass.name, block
    end

    def register
      instance_eval &@block
    end

    private

    def config
      return @config if defined? @config
      @config = (Units.units[@klass] ||= {})[@unit] = {}
    end

    def factor n_or_f, other
      unless other_config = Units.units[@klass][other]
        raise Error, "no such unit #{other.inspect}"
      end

      config[:factor] = Rational other_config[:factor], n_or_f
    end

    def baseline
      config[:factor] = 1
    end

    def metric *prefixes
      config[:metric] = true
      METRIC_MAP.each_pair do |prefix, factor|
        next unless prefixes.empty? || prefixes.include?(prefix)


      end
    end

    def rule other, &block
      (config[:rules] ||= {})[other] = block
    end

    def match regexp = nil
      regexp ? config[:matcher] = regexp : config[:matcher]
    end

    def train wheels
      Units.classifier.add_category @unit

      case wheels
      when Array
        wheels = wheels
      when Symbol
        file = File.join File.dirname(__FILE__), '..', 'data', "#{wheels}.yml"
        wheels = YAML.load_file File.expand_path(file)
      end

      wheels.each { |wheel| Units.classifier.train @unit, wheel }
    end
  end
end
