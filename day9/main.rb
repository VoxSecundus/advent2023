class History
  attr_reader :vals

  def initialize(vals)
    @vals = vals.map(&:to_i)
    @next_history = generate_next_step
  end

  def generate_next_step
    unless @vals.all?(&:zero?)
      next_vals = []

      @vals.each_with_index do |v, i|
        next if i.zero?

        next_vals << v - @vals[i - 1]
      end

      History.new(next_vals)
    end
  end

  def extrapolate(direction)
    array_message = direction == :forward ? :<< : :unshift

    if @vals.all?(&:zero?)
      @vals.send(array_message, 0)
    else
      @next_history.send(:extrapolate, direction)
      next_val = case direction
                 when :forward
                   @vals.last + @next_history.vals.last
                 else
                   @vals.first - @next_history.vals.first
                 end

      @vals.send(array_message, next_val)
      direction == :forward ? @vals.last : @vals.first
    end
  end

  def tree
    "#{@vals.join(' ')}\n#{@next_history&.tree}"
  end
end


def part_one(input)
  histories = input.split("\n").map { |h| History.new(h.split(' ')) }

  histories.map { |h| h.extrapolate(:forward) }.sum
end

def part_two(input)
  histories = input.split("\n").map { |h| History.new(h.split(' ')) }

  histories.map { |h| h.extrapolate(:backward) }.sum
end

INPUT = File.read(File.join(File.dirname(__FILE__), 'input'))

starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
puts "Part 1: #{part_one(INPUT)}"
puts "Part 2: #{part_two(INPUT)}"
ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
elapsed = ending - starting
puts "Elapsed: #{elapsed}"
