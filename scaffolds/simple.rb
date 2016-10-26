# "Simple" challenge. Each "pulse" from the source is represented by a single
# "1" or "0". A pair of pulses is called a "frame", and will represent a binary
# "bit".
#
# If the frame is "01", then the bit is a "0".
# If the frame is "10", then the bit it a "1".
#
# You should never receive a frame that is "00" or "11"; if you see one of those
# then you probably have a timing problem somewhere.
#
# Read 8 bit and join them together to get one binary "byte".
#
# The first byte you read will be the "payload size" and will need to be
# converted in to an integer. This number tells you how many remaining bytes are
# left in the source stream.
#
# Once you have read the payload size, keep reading one byte from the source and
# convert it in a character (not an integer). Keep doing this until you have
# read the number of bytes indicated by payload size.
#
# Then, stop reading the source and combine all your characters in to a string.
# Check if this new string is the correctly decoded data by calling the
# `#payload_correct?` method. If that returns true then it is correct.

require_relative '../manchester'

@source = Manchester::Simple.new

@payload = ''

def get_pulse
	@source.read_signal.to_s
end

def make_frame
	frame = ''
	2.times do
		frame << get_pulse
	end
	frame
end

def frame_to_binary
	if make_frame == '01'
		'0'
	else
		'1'
	end
end

def make_byte
	byte = ''
	8.times do
		byte << frame_to_binary
	end
	byte
end

def payload_size
	make_byte.to_i(2)
end

def byte_to_char
	make_byte.to_i(2).chr
end

def decode_message
	payload_size.times do
		@payload <<  byte_to_char
	end
end

decode_message

puts "Decoded payload is #{@payload.inspect}."
if @source.payload_correct?(@payload)
  puts "Payload is correct!"
else
  puts "Payload is not correct."
end
