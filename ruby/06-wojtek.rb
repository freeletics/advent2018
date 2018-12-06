test = """
1, 1
1, 6
8, 3
3, 4
5, 5
8, 9
""".strip

class Point
  attr_reader :x, :y, :label

  def initialize(x,y,label)
    @x = x
    @y = y
    @label = label
  end

  def distance_to(px, py)
    (px - x).abs + (py - y).abs
  end

  def finite?(grid, max)
    grid.select { |cords, point| point == self }.none? do |cords, point|
      [0, max].include?(cords.first) || [0, max].include?(cords.last)
    end
  end

  def to_s
    "#{@label}"
  end
end


points = []
File.read("inputs/06.txt").each_line.with_index do |line, i|
# test.split("\n").each.with_index do |line, i|
  cords = line.split(", ").map(&:to_i)
  points << Point.new(cords[0], cords[1], "P#{i}")
end
p points
max = [points.map(&:x).max, points.map(&:y).max].max
# puts "#{max}"

grid = {}

0.upto(max) do |x|
  0.upto(max) do |y|
    min = points.min_by(2) do |p|
      p.distance_to(x, y)
    end

    grid[[x,y]] = min.first.distance_to(x,y) == min.last.distance_to(x,y) ? "." : min.first
  end
end
# pp grid

# p points.map { |p| grid.values.count { |v| v == p } }.sort

finite = points.select do |p|
  p.finite?(grid, max)
end

winner = finite.max_by do |p|
  grid.values.count { |v| v == p }
end
puts winner
puts grid.values.count { |v| v == winner }

# distance = 32
distance = 10_000

wide_distance = 0
0.upto(max) do |x|
  0.upto(max) do |y|
    distances = points.map do |p|
      p.distance_to(x, y)
    end
    if distances.sum < distance
      wide_distance += 1
    end

    # grid[[x,y]] = min.first.distance_to(x,y) == min.last.distance_to(x,y) ? "." : min.first
  end
end
puts wide_distance
