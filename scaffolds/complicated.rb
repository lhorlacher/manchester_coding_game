# "Complicated" challenge. Each "pulse" from the source is represented by a run
# of many "1" or "0". Each of these runs will need to be detected and turned
# in to a single pulse, which will then be combined in to a frame and translated
# to as bit.
# If the frame is "00000000001111111111", then the bit is a "0".
# If the frame is "11111111110000000000", then the bit it a "1".
#
# REMEMBER: you can see how long a pulse is (the number of 1s or 0s in it) by
# using the source#pulse_size.

require_relative '../manchester'

@source = Manchester::Complicated.new

@payload = ''

@pulse_size = @source.pulse_size

def get_pulse
	pulse = nil
	@pulse_size.times do
		if pulse
			@source.read_signal.to_s
		else
			pulse = @source.read_signal.to_s
		end
	end
	pulse
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
