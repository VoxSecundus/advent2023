class Scratchcard
  attr_reader :id

  def initialize(line)
    @id = line.match(/Card\s*(\d+)/)[1]
    @winners = line.match(/: (.*) \|/)[1].split(' ')
    @numbers = line.match(/\|\s*(.*)/)[1].split(' ')
  end

  def wins
    @numbers.count { |n| @winners.include?(n) }
  end

  def score
    score = 0
    @numbers.each do |n|
      if @winners.include?(n)
        score.zero? ? score = 1 : score *= 2
      end
    end

    score
  end
end

def part_one(input)
  cards = input.split("\n").map { |l| Scratchcard.new(l) }
  cards.map(&:score).sum
end

def part_two(input)
  cards = input.split("\n").map { |l| Scratchcard.new(l) }
  to_process = {}
  count=0

  cards.each do |c|
    to_process[c.id] = [c]
  end

  to_process.each do |group, list|
    list.each do |card|
      wins = card.wins
      ((card.id.to_i + 1)..(card.id.to_i + wins)).each do |i|
        to_process[i.to_s] << cards[i-1]
        count += 1
      end
    end
  end

  count + cards.length
end

INPUT = File.read(File.join(File.dirname(__FILE__), 'input'))

puts "Part 1: #{part_one(INPUT)}"
puts "Part 2: #{part_two(INPUT)}"
