class Race
  def initialize(time, distance)
    @time = time.to_i
    @record = distance.to_i
  end

  def simulate(hold_time=0)
    (hold_time * (@time - hold_time))
  end

  def number_of_record_beaters
    1.upto(@time).select { |i| simulate(i) > @record }.count
  end
end

def part_one(input)
  times = input.lines.first.split(/\s+/)[1..]
  distances = input.lines.last.split(/\s+/)[1..]

  races = times.length.times.map { |i| Race.new(times[i], distances[i]) }

  races.map(&:number_of_record_beaters).reduce(1) { |n, i| n * i }
end

def part_two(input)
  time = input.lines.first.split(/\s+/)[1..].join
  distance = input.lines.last.split(/\s+/)[1..].join

  race = Race.new(time, distance)

  race.number_of_record_beaters
end

INPUT = File.read(File.join(File.dirname(__FILE__), 'input'))

starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
puts "Part 1: #{part_one(INPUT)}"
puts "Part 2: #{part_two(INPUT)}"
ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
elapsed = ending - starting
puts "Elapsed: #{elapsed}"
