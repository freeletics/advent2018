#!/usr/bin/env ruby

claims = File.readlines("inputs/03.txt").map(&:chomp)
# claims = [
#   "#1 @ 1,3: 4x4",
#   "##2 @ 3,1: 4x4",
#   "##3 @ 5,5: 2x2"
# ]

fabric = Array.new(1000) { Array.new(1000) {0} }

claims.each_with_index do |claim, index|
  pos, size = claim.split("@").last.split(":")
  x_pos, y_pos = pos.split(",").map(&:to_i)
  x_width, y_width = size.split("x").map(&:to_i)

  (x_pos...x_pos + x_width).each do |x|
    (y_pos...y_pos + y_width).each do |y|
      if fabric[y][x] != 0
        fabric[y][x] = "x"
      else
        fabric[y][x] = index + 1
      end
    end
  end
end

puts "Area under overlap: #{fabric.flatten.count("x")}"

claims.each_with_index do |claim, index|
  pos, size = claim.split("@").last.split(":")
  x_pos, y_pos = pos.split(",").map(&:to_i)
  x_width, y_width = size.split("x").map(&:to_i)

  overlaps = false
  (x_pos...x_pos + x_width).each do |x|
    (y_pos...y_pos + y_width).each do |y|
      next if fabric[y][x] == index + 1
      overlaps = true and break
    end
    break if overlaps
  end

  puts "Claim: #{index + 1}" and break unless overlaps
end
