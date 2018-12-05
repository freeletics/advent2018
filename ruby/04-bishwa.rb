#!/usr/bin/env ruby

require 'date'

logs = File.readlines("inputs/04.txt").map(&:chomp)

# test_text =<<~TESTTEXT
# [1518-11-01 00:00] Guard #10 begins shift
# [1518-11-01 00:05] falls asleep
# [1518-11-01 00:25] wakes up
# [1518-11-01 00:30] falls asleep
# [1518-11-01 00:55] wakes up
# [1518-11-01 23:58] Guard #99 begins shift
# [1518-11-02 00:40] falls asleep
# [1518-11-02 00:50] wakes up
# [1518-11-03 00:05] Guard #10 begins shift
# [1518-11-03 00:24] falls asleep
# [1518-11-03 00:29] wakes up
# [1518-11-04 00:02] Guard #99 begins shift
# [1518-11-04 00:36] falls asleep
# [1518-11-04 00:46] wakes up
# [1518-11-05 00:03] Guard #99 begins shift
# [1518-11-05 00:45] falls asleep
# [1518-11-05 00:55] wakes up
# TESTTEXT

# logs = test_text.split("\n").map(&:chomp)
Log = Struct.new(:date, :info)

logs = logs.map do |log|
  date, info = log.split("]")
  Log.new(
    DateTime.strptime(date.delete_prefix("[").strip, "%Y-%m-%d %H:%M"),
    info.strip
  )
end.sort_by {|e| e.date}

puts "parsed log:"
logs.each {|e| puts "#{e.date.to_s} : #{e.info}"}

GuardAction = Struct.new(:guard_id, :date, :sleep_time, :awake_time)

sleep_record = {}

current_record = GuardAction.new

logs.each do |log|
  if log.info =~ /wakes/
    current_record.awake_time = log.date.minute
    if sleep_record[current_record.guard_id]
      sleep_record[current_record.guard_id] << current_record
    else
      sleep_record[current_record.guard_id] = [current_record]
    end
    current_record = GuardAction.new(current_record.guard_id, current_record.date)
  elsif log.info =~ /falls/
    current_record.sleep_time = log.date.minute
  else
    guard_id = log.info.match(/#(\d+)/).captures.first.to_i
    current_record = GuardAction.new(guard_id, log.date)
  end
end

guard_id, _ = sleep_record.max_by do |key, values|
  values.map{|e| e.awake_time - e.sleep_time}.inject(:+)
end

puts "Guard #{guard_id} slept for maximum number of minutes"

def max_minute_frequency(records)
  minute_record = {}
  records.each do |guard_action|
    (guard_action.sleep_time...guard_action.awake_time).each do |minute|
      if minute_record[minute]
        minute_record[minute] += 1
      else
        minute_record[minute] = 1
      end
    end
  end
  minute_record.max_by {|k,v| v}
end

max_minute, _ = max_minute_frequency(sleep_record[guard_id])

puts "Guard #{guard_id} slept freqeuntly on: #{max_minute} minute"

puts "Answer 1: #{guard_id * max_minute}"
max_value = -1
found_key = sleep_record.keys.first
found_minute = 0

sleep_record.each do |key, values|
  minute, value = max_minute_frequency(values)
  if value > max_value
    max_value = value
    found_key = key
    found_minute = minute
  end
end

puts "Guard #{found_key} slept maximum time #{max_value} on '00:#{found_minute}' minute time"
puts "Answer 2: #{found_key * found_minute}"
