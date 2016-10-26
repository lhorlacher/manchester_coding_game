module Manchester
  class Complex < Complicated

    def pulses
      @pulses ||= begin
        # insert some 1-pulse errors in to super
        super.tap{|pulse_array|
          3.times do
            location = rand(pulse_array.length)
            pulse_array[location] = (pulse_array[location] == 1 ? 0 : 1)
          end
        }
      end
    end
  end
end
