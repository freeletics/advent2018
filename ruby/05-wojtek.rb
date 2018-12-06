test = """
dabAcCaCBAcCcaDA
""".strip
input = File.read("inputs/05.txt").strip
# input = test

def reduce(chars)
  changes = true
  while changes do
    changes = false

    chars.each_with_index do |ch, i|
      next_one = chars[i + 1]
      next if next_one.nil?

      if ch != next_one && ch.upcase == next_one.upcase
        chars.delete_at(i + 1)
        chars.delete_at(i)
        changes = true
        break
      end
    end
  end

  chars
end

chars = input.split("")
# puts reduce(chars.dup).size # part 1

to_remove = chars.uniq.map(&:downcase).uniq
to_remove.each do |char|
  copy = chars.dup
  copy.delete(char)
  copy.delete(char.upcase)
  puts "#{char} - #{reduce(copy).size}"
end
