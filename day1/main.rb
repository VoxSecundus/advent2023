NUMBERS = [
  *(1..9).map(&:to_s),
  'one',
  'two',
  'three',
  'four',
  'five',
  'six',
  'seven',
  'eight',
  'nine'
]


def part_one(inputs)
  inputs.split("\n").inject(0) do |x, input|
    stripped = input.tr('^0-9', '')
    digits = stripped[0] + stripped[-1]
    digits.to_i + x
  end
end

def part_two(inputs)
  exp = Regexp.new("(?=(#{NUMBERS.join('|')}))")

  inputs.split("\n").inject(0) do |x, input|
    nums = input.scan(exp).compact
    nums = [nums.first, nums.last].flatten

    digits = nums.map { |n| (NUMBERS.index(n) % 9 + 1).to_s }.reduce(:+)

    digits.to_i + x
  end
end

INPUT = File.read(File.join(File.dirname(__FILE__), 'input'))

starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
puts "Part 1: #{part_one(INPUT)}"
puts "Part 2: #{part_two(INPUT)}"
ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
elapsed = ending - starting
puts "Elapsed: #{elapsed}"
