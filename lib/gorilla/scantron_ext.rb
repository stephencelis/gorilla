require 'scantron'
require 'amount_scanner'

class NumberScanner
  words = WORD_MAP.keys.map { |v| v.sub /y$/, 'y-?' } * '|'
  rules[:human].regexp = \
    %r{(?:\b(?:\d+ (?:an?d? )*)?(?:#{words}))(?: ?\b(?:#{words}|an?d?|\d+)\b ?)*}i

  def self.human_to_number words
    numbers = words.split(/\W+/).map { |w|
      WORD_MAP[w.downcase] || parse(w) || w
    }

    case numbers.count { |n| n.is_a? Numeric }
      when 0 then false
      when 1 then numbers[0]
    else
      array = []
      total = 0
      limit = 1
      words = []
      reset = true

      numbers.each.with_index do |n, i|
        words << n and next if n.is_a? String

        if n == 1 && limit == 1
          reset = false
          next
        end

        if n >= 1_000
          total += n * limit
          limit = 1
          reset = true
        else
          if n < 1
            if words.join(' ') =~ /\band\b/
              if total > 0 && total % 1_000
                if total % (factor = 10 ** (total.to_i.to_s.size - 1)) == 0
                  limit = n * factor
                else
                  limit = n
                end
              else
                limit += n
              end
            else
              limit *= n
            end
          elsif words.join(' ') =~ /\band\b/ && numbers[i + 1].to_i < 1
            total += limit
            limit = n
          elsif !reset && limit >= 1 &&
            m1 = (n > (m2 = numbers[i + 1].to_i) ? n + m2 : n) and
            m = [limit, m1].sort and
            !m[1].to_s[-(m0 = m[0].to_i.to_s.size), m0].to_i.zero?

            array << total + limit
            total = 0
            limit = n
          elsif !reset && limit == 1 && n > numbers[i + 1].to_i &&
            m = [limit, n + numbers[i + 1].to_i].sort and
              !m[1].to_s[-(m[0].to_i.to_s.size), m[0].to_i.to_s.size].to_i.zero?

            array << total + limit
            total = 0
            limit = n
          else
            n > limit ? limit *= n : limit += n
          end

          total += limit if numbers[i + 1].nil?
          reset = false
        end

        words.clear
      end

      array.empty? ? total : array << total
    end
  end
end
