# "Complex" challenge. Each "pulse" from the source is represented by a run
# of many "1" or "0", just like in the "complicated" challenge, but now there
# are a few one-character errors in the stream. You will need to filter them
# out. For example:
#
# If the frame is "00001000001111111111", remove the error in the first pulse
# and read the bit as "0".
# If the frame is "11111111110000010000", remove the error in the second pulse
# and read the bit as "1".
#
# Note: There *may* be multiple errors in a single pulse, but there will never
# be more than 3 errors in total in the data. Errors are inserted at random and
# will change every time you run the code.

require_relative '../manchester'

@source = Manchester::Complex.new

@payload = ''

@pulse_size = @source.pulse_size

def get_pulse
	pulse = []
	@pulse_size.times do
		pulse << @source.read_signal.to_s
	end
	if pulse.count('1') > pulse.count('0')
		'1'
	else
		'0'
	end
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

