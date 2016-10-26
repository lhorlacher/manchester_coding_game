module Manchester
  class Base
    PAYLOAD_SIZE = [0,0,0,0,1,1,0,1] # Payload size 13

    MESSAGE = [
      [0,1,0,0,1,0,0,0], # H
      [0,1,1,0,0,1,0,1], # e
      [0,1,1,0,1,1,0,0], # l
      [0,1,1,0,1,1,0,0], # l
      [0,1,1,0,1,1,1,1], # o
      [0,0,1,0,1,1,0,0], # ,
      [0,0,1,0,0,0,0,0], # <space>
      [0,1,0,1,0,1,1,1], # W
      [0,1,1,0,1,1,1,1], # o
      [0,1,1,1,0,0,1,0], # r
      [0,1,1,0,1,1,0,0], # l
      [0,1,1,0,0,1,0,0], # d
      [0,0,1,0,1,1,1,0], # .
    ];

    # G.E. Thomas style, https://en.wikipedia.org/wiki/Manchester_code
    PULSE_DESCRIPTIONS = [
      [ 0, 1 ], # zero, low-high transition
      [ 1, 0 ]  # one, high-low transition
    ];

    def initialize
      @position = 0
    end

    def read_signal
      if pulse = pulses[@position]
        @position += 1
        pulse
      else
        gone_too_far!
      end
    end

    def gone_too_far!
      raise "Tried to read too many pulses from the source!"
    end

    def payload_correct?(payload)
      payload == "Hello, World."
    end
  end
end
