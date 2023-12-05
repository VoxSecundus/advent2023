class Map
  attr_reader :source, :destination, :transition_function

  def initialize(str)
    lines = str.split("\n").reject(&:empty?)
    id_line = lines.delete_at(0)

    @source, @destination = id_line.scan(/(.*)-to-(.*) map/).first

    @transition_function = {}

    lines.each do |line|
      dest_start, source_start, length = line.split(' ').map(&:to_i)

      source_range = source_start...(source_start + length)

      @transition_function[source_range] = dest_start
    end
  end

  def fetch(int)
    range = @transition_function.find { |k, _| k.include?(int) }
    range ? range[1] + (int - range[0].first) : int
  end
end

def part_one(input)
  seeds = input.lines.first.split(' ')[1..]

  maps = input.split(/^\s*$/)[1..].map { |s| Map.new(s) }

  seeds.map do |seed|
    next_val = seed.to_i
    current = maps.first.source
    while (map = maps.find { |m| m.source == current })
      new_val = map.fetch(next_val)
      next_val = new_val
      current = map.destination
    end
    next_val
  end.min
end

def percent(num, den)
  ((num.to_f / den) * 100).round(2)
end

def part_two(input)
  seed_ranges = input.lines.first.delete_prefix('seeds: ').split(' ').map(&:to_i)
  seed_ranges = seed_ranges.each_slice(2).to_a.map { |a| a[0]..(a[0] + a[1]) }

  #seeds = seed_ranges.reduce([]) { |a, r| a << Array(r) }.flatten
  len = seed_ranges.length

  maps = input.split(/^\s*$/)[1..].map { |s| Map.new(s) }

  final = []

  seed_ranges.each_with_index do |range, idx|
    results = []
    size = range.size
    range.each_with_index do |seed, idy|
      puts "range #{idx+1}; seed #{idy+1}/#{size}"
      #puts "range #{idx+1}; seed #{idy+1}/#{range.size} (#{percent(idy+1, range.size)}%)"
      next_val = seed.to_i
      current = maps.first.source
      while (map = maps.find { |m| m.source == current })
        new_val = map.fetch(next_val)
        next_val = new_val
        current = map.destination
      end
      results << next_val
    end
    results.min
  end

  final.min
end

def test_data(input)
  seed_ranges = input.lines.first.delete_prefix('seeds: ').split(' ').map(&:to_i)
  seed_ranges = seed_ranges.each_slice(2).to_a.map { |a| a[0]..(a[0] + a[1]) }

  seeds = seed_ranges.reduce([]) { |a, r| a << Array(r) }.flatten
  len = seeds.length

  maps = input.split(/^\s*$/)[1..].map { |s| Map.new(s) }

  seeds.to_enum(:each_with_index).map do |seed, idx|
    puts "seed #{idx+1}/#{len}"
    next_val = seed.to_i
    current = maps.first.source
    while (map = maps.find { |m| m.source == current })
      new_val = map.fetch(next_val)
      next_val = new_val
      current = map.destination
    end
    next_val
  end.min
end

INPUT = File.read(File.join(File.dirname(__FILE__), 'input'))
TEST = File.read(File.join(File.dirname(__FILE__), 'test'))

#puts "Test: #{test_data(TEST)}"
#puts "Part 1: #{part_one(INPUT)}"

starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
puts "Part 2: #{part_two(INPUT)}"
ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
elapsed = ending - starting
puts "Elapsed: #{elapsed}"
