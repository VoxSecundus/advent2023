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

inputs = File.read('./input').split("\n")

def part_one(inputs)
  inputs.inject(0) do |x, input|
    stripped = input.tr('^0-9', '')
    digits = stripped[0] + stripped[-1]
    digits.to_i + x
  end
end

def part_two(inputs)
  exp = Regexp.new("(?=(#{NUMBERS.join('|')}))")

  inputs.inject(0) do |x, input|
    nums = input.scan(exp).compact
    nums = [nums.first, nums.last].flatten

    digits = nums.map { |n| (NUMBERS.index(n) % 9 + 1).to_s }.reduce(:+)

    digits.to_i + x
  end
end

puts "Part 1: #{part_one(inputs)}"
puts "Part 2: #{part_two(inputs)}"
