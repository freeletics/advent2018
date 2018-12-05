#!/usr/bin/env ruby

input_text = File.readlines("inputs/05.txt").first.chomp.strip.chars.map(&:ord)

# input_text = "dabAcCaCBAcCcaDA".chars.map(&:ord)

def find_shortest_polymer_length(text)
  left_flag = 0
  right_flag = 1
  loop do
    left_char = text[left_flag].dup
    right_char = text[right_flag].dup
    break unless left_char && right_char
    if (left_char - right_char).abs == 32
      text.delete_at(left_flag)
      text.delete_at(left_flag)
      left_flag -= 1
      right_flag -= 1
    else
      left_flag += 1
      right_flag += 1
    end
  end
  text.count
end

puts "Final polymer length: #{find_shortest_polymer_length(input_text.dup)}"
min_length = input_text.count

(65..90).each do |chr|
  next unless input_text.include? chr
  working_text = input_text.dup
  working_text.delete(chr)
  working_text.delete(chr + 32)
  length = find_shortest_polymer_length(working_text)
  if length < min_length
    min_length = length
  end
end

puts "Minumum polymer length after destruction: #{min_length}"
