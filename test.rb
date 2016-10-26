require_relative './manchester'
source = Manchester::ComplexPlus.new
# source = Manchester::Complex.new
# puts source.pulses.map(&:inspect).join("\n")
puts '---'
# puts source.pulses.map{|p| p.size}.uniq.sort.join("\n")
puts source.pulses.size
