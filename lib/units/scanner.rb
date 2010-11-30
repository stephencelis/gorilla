module Units
  class Scanner < ::Scantron::Scanner
    METRIC_MAP = {
      :milli => /m(?:illi)?/,
      :centi => /c(?:enti)?/,
      :kilo  => /k(?:ilo)?/
    }

    @default = lambda { |r|
      pre_match = r.scanner.pre_match

      result = [
        RangeScanner.new(pre_match).perform.last,
        NumberScanner.new(pre_match).perform.last
      ].compact.flatten.sort.last

      amount = result.value if result
      Units.const_get(r.rule.data[:class]).new amount, r.name
    }

    def self.rule name, regexp, data = {}, &block
      config = { :metric => false }.update data
      config.update :class => self.name.sub(/Scanner$/, '')
      super name, /(?<=^|[\d ])#{regexp}\b/, config, &block

      if config[:metric]
        METRIC_MAP.each_pair do |pre, sub|
          super :"#{pre}#{name}", /\b#{sub}#{regexp}\b/, config, &block
        end
      end
    end
  end
end
