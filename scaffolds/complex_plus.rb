# "Complex-Plus" challenge. Signals are structured like in "complicated" and
# "complex", but here the length of each pulse may vary slightly over time
# from the value in source.pulse_size. You will need to allow for the changes
# at the edge of the frames and between pulses to be slightly out of sync. They
# won't be more than 10 percent off.

require_relative '../manchester'

@source = Manchester::ComplexPlus.new

@payload_size = nil

@payload = ''

PULSE_SIZE = @source.pulse_size

#Required count per sequence to be considered a pulse
MIN_RUN_COUNT = (PULSE_SIZE * 0.9 - 1).to_i + 1


@zero_count = 0
@one_count = 0

@frame = ''
@byte = ''

def get_pulses
	while
		begin 
			case @source.read_signal.to_s
				when '0'
					@zero_count += 1
				when '1'
					@one_count += 1
			end
		rescue
			puts "Message fully received."
			break
		end
		check_for_mins
	end
end

def check_for_mins
	if @zero_count == MIN_RUN_COUNT
		@frame << '0'
		reset_counters
		check_for_frame
	elsif @one_count == MIN_RUN_COUNT
		@frame << '1'
		reset_counters
		check_for_frame
	end
end

def check_for_frame
	if @frame.length == 2
		@byte << frame_to_binary
		@frame = ''
		check_for_byte
	end
end

def check_for_byte
	if @byte.length == 8
		if @payload_size
			@payload << @byte.to_i(2).chr
			@byte = ''
		else 
			@payload_size = @byte.to_i(2)
			@byte = ''
		end
	end
end

def reset_counters
	@zero_count = 0
	@one_count = 0
end

def frame_to_binary
	if @frame == '01'
		@frame = ''
		'0'
	else
		@frame = ''
		'1'
	end
end

get_pulses

puts "Decoded payload is #{@payload.inspect}."
if @source.payload_correct?(@payload)
  puts "Payload is correct!"
else
  puts "Payload is not correct."
end
