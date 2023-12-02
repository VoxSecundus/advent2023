class Game
  MAXIMUMS = {
    green: 13,
    red: 12,
    blue: 14
  }

  COLOURS = MAXIMUMS.keys

  attr_reader :id

  def initialize(line)
    matches = line.match(/Game (.*): (.*)/)

    @id = matches[1].to_i
    @rounds = []

    matches[2].split(';').each do |round|
      @rounds << Round.new(round)
    end
  end

  def possible?
    COLOURS.all? do |col|
      @rounds.all? do |round|
        round.public_send(col) <= MAXIMUMS[col]
      end
    end
  end

  def cubes_power
    minimum_needed.values.reduce(1, :*)
  end

  def minimum_needed
    COLOURS.map do |c|
      [c, @rounds.map { |r| r.send(c) }.max]
    end.to_h
  end

  class Round
    attr_reader :blue, :red, :green

    def initialize(str)
      @blue = @red = @green = 0

      str.split(',').map(&:strip).each do |grab|
        matches = grab.match(/(\d*)\s(.*)/)

        instance_variable_set("@#{matches[2]}", matches[1].to_i)
      end
    end
  end
end

def part_one(games)
  games.select(&:possible?).map(&:id).sum
end

def part_two(games)
  games.map(&:cubes_power).sum
end

INPUT = File.read('./input')

games = INPUT.split("\n").map { |l| Game.new(l) }

puts "Part 1: #{part_one(games)}"
puts "Part 2: #{part_two(games)}"
