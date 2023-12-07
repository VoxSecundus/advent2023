require 'set'

class Game
  attr_reader :cards, :joker

  def initialize(cards, joker: nil)
    @cards = cards
    @joker = joker
  end

  def hand(str, bid)
    Hand.new(str, bid, self)
  end

  def sort_hand(hand)
    hand.chars.sort_by { |c| @cards.index(c) }.join
  end

  class Hand
    TYPES = [
      { '5OAK' => Proc.new { |s, g| s.chars.uniq.length == 1 } },
      { '40AK' => Proc.new { |s, g| g.sort_hand(s).match(/([0-9JQKAT])\1{3}/) } },
      { 'FH' =>   Proc.new { |s, g| s.chars.group_by(&:itself).values.map(&:count).sort == [2,3] } },
      { '3OAK' => Proc.new { |s, g| g.sort_hand(s).match(/([0-9JQKAT])\1{2}/) } },
      { '2P' =>   Proc.new { |s, g| s.chars.group_by(&:itself).values.map(&:count).sort == [1,2,2] } },
      { '1P' =>   Proc.new { |s, g| s.chars.group_by(&:itself).values.map(&:count).sort == [1,1,1,2] } },
      { 'HI' =>   Proc.new { |s, g| s.chars.uniq.length == 5 } }
    ].map { |t| { 'name' => t.keys.first, 'proc' => t.values.first } }

    attr_reader :value, :type, :bid

    def initialize(str, bid, game)
      @value = str
      @bid = bid.to_i
      @game = game
    end

    def joker
      @game.joker
    end

    def <=>(other)
      my_index = best_type_index
      other_index = other.best_type_index

      if my_index == other_index
        map_vals <=> other.map_vals
      else
        other_index <=> my_index
      end
    end

    def best_type_index
      possibles = case joker.nil?
                  when false
                    @game.cards.length.times.map do |i|
                      hand = Hand.new(@value.gsub(joker, @game.cards[i]), @bid, @game)
                    end
                  else
                    [self]
                  end

      possibles.map(&:type_index).min
    end

    def best_type
      TYPES[best_type_index]
    end

    def type
      TYPES.find { |t| t['proc'].call(@value, @game) }['name']
    end

    def type_index
      TYPES.map { |t| t['name'] }.index(type)
    end

    def map_vals
      @value.chars.map { |c| @game.cards.index(c) }
    end
  end
end

def part_one(input)
  values = %w(2 3 4 5 6 7 8 9 T J Q K A)
  game = Game.new(values)

  hands = input.split("\n").map { |l| game.hand(*l.split(' ')) }.sort

  hands.reduce(0) { |n, h| n + h.bid * (hands.index(h) + 1) }
end

def part_two(input)
  values = %w(J 2 3 4 5 6 7 8 9 T Q K A)
  game = Game.new(values, joker: 'J')

  hands = input.split("\n").map { |l| game.hand(*l.split(' ')) }.sort

  hands.reduce(0) { |n, h| n + h.bid * (hands.index(h) + 1) }
end

INPUT = File.read(File.join(File.dirname(__FILE__), 'input'))

starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
puts "Part 1: #{part_one(INPUT)}"
puts "Part 2: #{part_two(INPUT)}"
ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
elapsed = ending - starting
puts "Elapsed: #{elapsed}"
