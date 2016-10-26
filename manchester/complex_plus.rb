# Pulse size increases over time, expecting the caller to dynamically adjust
# their own pulse_size clock.
module Manchester
  class ComplexPlus < Base
    PULSE_SIZE = 100
    VARIANCE_INC_SIZE = 1 # amount to increase pulse size
    VARIANCE_INC_INTERVAL = PULSE_SIZE*0.7 # how often to increase pulse size, in pulses

    def pulse_size
      PULSE_SIZE
    end

    # TODO: also have errors in this?
    # Generates pulses where the length slowly increases over time to where
    # the Complex and Complicated solutions will eventually fail when used with
    # this source.
    def pulses
      @pulses ||= begin
        counter = 0
        current_pulse_size = PULSE_SIZE

        ([PAYLOAD_SIZE] + MESSAGE).map{|byte|
          byte.map{|bit|
            if (counter += 1) % VARIANCE_INC_INTERVAL == 0
              current_pulse_size += VARIANCE_INC_SIZE
            end
            PULSE_DESCRIPTIONS[bit].map{|pulse|
              pulse.to_s * current_pulse_size
            }.join
          }.join
        }.join.split('').map(&:to_i)
      end
    end
  end
end
