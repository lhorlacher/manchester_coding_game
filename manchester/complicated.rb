module Manchester
  class Complicated < Base
    PULSE_SIZE = 10

    def pulse_size
      PULSE_SIZE
    end

    # Pulses expanded out to 10 times
    EXPANDED_PULSE_DESCRIPTIONS = [
      [ PULSE_SIZE.times.map{0}, PULSE_SIZE.times.map{1} ], # zero, low-high transition
      [ PULSE_SIZE.times.map{1}, PULSE_SIZE.times.map{0} ]  # one, high-low transition
    ];

    def pulses
      @pulses ||= ([PAYLOAD_SIZE] + MESSAGE).map{|byte| byte.map{|bit| EXPANDED_PULSE_DESCRIPTIONS[bit]}}.flatten
    end

  end
end
