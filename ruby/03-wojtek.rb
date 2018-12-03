class Claim
  attr_reader :id, :left, :top, :wide, :tall

  def initialize(source)
    parts = source.split(" ")
    @id = parts[0].sub("#", "").to_i
    @left, @top = parts[2].sub(":", "").split(",").map(&:to_i)
    @wide, @tall = parts[3].split("x").map(&:to_i)
  end

  def to_s
    "#{id} @ #{left},#{top}: #{wide}x#{tall}"
  end
end

claims = []
test = """
#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2
""".strip
File.read("inputs/03.txt").each_line do |line|
# test.split("\n").each do |line|
  claims << Claim.new(line)
end

fabric = Hash.new(0)

claims.each do |claim|
  claim.left.upto(claim.left - 1 + claim.wide) do |x|
    claim.top.upto(claim.top - 1 + claim.tall) do |y|
      # puts "#{x}, #{y}"
      fabric[[x, y]] += 1
    end
  end
end
puts fabric.values.count { |a| a >= 2}

claims.each do |claim|
  size = claim.wide * claim.tall
  counter = 0
  claim.left.upto(claim.left - 1 + claim.wide) do |x|
    claim.top.upto(claim.top - 1 + claim.tall) do |y|
      # puts "#{x}, #{y}"
      counter += 1 if fabric[[x,y]] == 1
    end
  end

  if size == counter
    puts claim.id
    exit
  end
end
