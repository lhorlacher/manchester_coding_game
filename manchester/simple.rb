module Manchester
  class Simple < Base
    def pulse_size
      1
    end

    def pulses
      @pulses ||= ([PAYLOAD_SIZE] + MESSAGE).map{|byte| byte.map{|bit| PULSE_DESCRIPTIONS[bit]}}.flatten
    end
  end
end
