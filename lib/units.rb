require 'classifier'
require 'strscan'
require 'yaml'
require 'units/base'
require 'units/measurement'

module Units
  class ParsingError < StandardError
  end

  @units = {}
  @classifier = Classifier::Bayes.new

  class << self
    attr_reader :units
    attr_reader :classifier

    def scan string, filter = nil
      scanner = StringScanner.new string
      results = []

      units.each_pair do |klass_name, configs|
        next if filter && filter != klass

        configs.each_key do |unit|
          next unless rule = self[klass_name, unit]
          while scanner.skip_until rule
            klass = const_get klass_name[/\w+$/]
            pos = [scanner.pos - scanner.matched_size, scanner.matched_size]
            results << klass.new(scanner[1].to_f, unit, :pos => pos)
          end

          scanner.pos = 0
        end
      end

      results.sort_by! { |result| result.pos }

      to_delete = []
      results.each.with_index { |result, i|
        if next_result = results[i + 1] and next_result.pos[0] == result.pos[0]
          category = result.unit.to_s.capitalize.gsub /_/, ' '
          next unless classifier.categories.include? category
          prev_result = results[i - 1] if i > 0
          next_pos = results[i + 2] ? results[i + 2].pos[0] : string.length
          next_result = string[(result.pos[0] + result.pos[1])..next_pos]
          string = "#{prev_result} #{string[*result.pos]} #{next_result}"
          to_delete << (classifier.classify(string) == category ? i + 1 : i)
        end
      }

      to_delete.reverse.each { |i| results.delete_at i }
      results
    end

    def parse string, filter = nil
      scan(string, filter).inject { |x, y| x + y }
    end

    def [] klass, unit
      if rule = units[klass][unit][:matcher]
        /(#{Measurement::NUMBER_RANGE}) ?#{rule}\b/
      end
    end
  end
end
