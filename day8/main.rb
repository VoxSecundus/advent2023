class Map
  Location = Struct.new(:l, :r)

  attr_reader :locations, :cursor

  def initialize
    @locations = {}
    @cursor = nil
  end

  def traverse(direction)
    self.tap do
      @cursor = @locations[@cursor].send(direction.downcase)
    end
  end

  def place_cursor(id)
    return unless @locations[id]

    self.tap do
      @cursor = id
    end
  end

  def add_location(id, left, right)
    self.tap do
      @locations[id] = Location.new(left, right)
    end
  end
end

def initialize_map(input)
  Map.new.tap do |map|
    locations = input.lines[2..].map(&:strip)

    locations.each do |line|
      id = line.match(/^[^ ]*/)[0]
      left, right = line.match(/\(([^)]+)\)/)[1].split(', ')

      map.add_location(id, left, right)
    end
  end
end

def part_one(input)
  map = initialize_map(input)
  path = input.lines.first.chars

  map.place_cursor('AAA')
  count = 0
  mod = path.length - 1

  until map.cursor == 'ZZZ'
    map.traverse(path[count % mod])
    count += 1
  end

  count
end

def part_two(input)
  map = initialize_map(input)
  path = input.lines.first.chars
  mod = path.length - 1
  start = /.*A/
  automata = []
  distances = []

  map.locations.each do |id, _|
    next unless id.match(start)

    automata << map.dup.place_cursor(id)
  end

  automata.each_with_index do |m, idx|
    count = 0
    until m.cursor.chars.last == 'Z'
      m.traverse(path[count % mod])
      count += 1
    end

    distances << count
  end

  distances.reduce(1) { |acc, n| acc.lcm(n) }
end

INPUT = File.read(File.join(File.dirname(__FILE__), 'input'))

starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
puts "Part 1: #{part_one(INPUT)}"
puts "Part 2: #{part_two(INPUT)}"
ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
elapsed = ending - starting
puts "Elapsed: #{elapsed}"
