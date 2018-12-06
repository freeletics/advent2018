test = """
[1518-11-01 00:00] Guard #10 begins shift
[1518-11-01 00:05] falls asleep
[1518-11-01 00:25] wakes up
[1518-11-01 00:30] falls asleep
[1518-11-01 00:55] wakes up
[1518-11-01 23:58] Guard #99 begins shift
[1518-11-02 00:40] falls asleep
[1518-11-02 00:50] wakes up
[1518-11-03 00:05] Guard #10 begins shift
[1518-11-03 00:24] falls asleep
[1518-11-03 00:29] wakes up
[1518-11-04 00:02] Guard #99 begins shift
[1518-11-04 00:36] falls asleep
[1518-11-04 00:46] wakes up
[1518-11-05 00:03] Guard #99 begins shift
[1518-11-05 00:45] falls asleep
[1518-11-05 00:55] wakes up
""".strip

require "time"

class Activity
  attr_reader :at, :work

  def initialize(source)
    parts = source.split("] ")
    @at = Time.parse(parts[0].sub("[", ""))
    @work = parts[1]
  end

  def to_s
    "[#{@at}] #{@work}"
  end
end
entries = []
File.read("inputs/04.txt").each_line do |line|
# test.split("\n").each do |line|
  entries << Activity.new(line)
end
entries.sort_by!(&:at)
series = entries.slice_when { |_e1, e2| e2.work.match?("begins shift") }.to_a

group = series.group_by { |group| group.first.work.split(" ")[1].sub("#", "").to_i }
# pp group

final = group.keys.each_with_object({}) do |id, result|
  shifts = group[id]
  result[id] = shifts.map do |day|
    hours = Array.new(60) { 1 } # awake by default

    day.shift # beginning
    pairs = day.each_slice(2)
    pairs.each do |start, stop|
      start.at.min.upto(stop.at.min - 1) { |i| hours[i] = 0 } # sleeps
    end
    hours
  end
end

id, = final.max_by do |id, days|
  days.map do |day|
    day.count { |d| d == 0 }
  end.sum
end
asleep = Array.new(60) { 0 }
final[id].each do |day|
  day.each_with_index do |w, i|
    asleep[i] += 1 if w == 0
  end
end
max = asleep.max
puts asleep.index(max) * id


most = final.keys.each_with_object({}) do |id, result|
  days = final[id]
  sleeps = Array.new(60) { 0 }
  days.each do |day|
    day.each_with_index do |s, i|
      sleeps[i] += 1 if s == 0
    end
  end

  result[id] = sleeps
end

id, = most.max_by do |id, sleep|
  sleep.max
end
max = most[id].max
puts id * most[id].index(max)
