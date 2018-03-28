#!/usr/bin/env ruby

prev_total = 0
prev_idle = 0

cpu = File.read('/proc/stat').each_line.find{|line| /^cpu\s/ =~ line}.sub('cpu', '').strip.split(' ')
idle = cpu[3].to_i
total = 0
cpu.each{|i| total += i.to_i}
diff_idle  = idle - prev_idle
diff_total = total - prev_total
diff_usage = (1000 * (diff_total - diff_idle)/diff_total+5)/10
prev_total = total
prev_idle = idle

sleep 1

cpu = File.read('/proc/stat').each_line.find{|line| /^cpu\s/ =~ line}.sub('cpu', '').strip.split(' ')
idle = cpu[3].to_i
total = 0
cpu.each{|i| total += i.to_i}
diff_idle  = idle - prev_idle
diff_total = total - prev_total
diff_usage = (1000 * (diff_total - diff_idle)/diff_total+5)/10
prev_total = total
prev_idle = idle

puts diff_usage
