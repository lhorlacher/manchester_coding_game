# Manchester Coding Challenge
###### URUG, SLC.rb, October 2016 , https://github.com/xunker/urug_manchester

Have you ever heard of
[Manchester coding](https://en.wikipedia.org/wiki/Manchester_code)?
It is a way to send data over a single wire and then decode it at the other end.
It's old, invented in the 1940s, but it's still in use today in things like
Ethernet, radio transmitters and television remote controls.

This challenge is to take a stream of Manchester-coded binary data and convert
it back into meaningful data using Ruby, a programming language that would be
invented until fifty years later!

## Goals

* Learn how to create state machines.
* Learn how to convert binary in to a number or character.
* Show how digital data can be transmitted over a wire.
* Show how "[endianness](https://en.wikipedia.org/wiki/Endianness)" works in the
real world.
* Illustrate the importance of smoothing and debouncing.
* Examine the technical details of how computers communicate with each other.


## Challenges
The challenges are tiered in difficulty, from easiest to hardest:
  * _Simple_: Read single characters (1/0), each representing one pulse. Convert
  pairs of pulses to a binary bit, groups of 8 bits to get a byte, decode the
  message.
  * _Complicated_: Pulses are n-groupings of 1/0, so you have to look for a
  state change in the stream.
  * _Complex_: Small errors (e.g. line noise) are injected in to the stream so
  you will need to smooth the input to filter them out.
  * _Complex-Plus_: The length of the the pulses will vary over the length of
  the message to simulate clock skew, so your code will need to dynamically adjust.

Each challenge includes the one above it and adds an additional piece. A correct
solution a challenge will also successfully decode the data for the previous
challenges.

## How to get started

You will need to understand the basics of Manchester Coding, and what a "pulse",
"frame", "bit", "byte", and "mid-bit transition" mean. If you don't have a
presenter or instructor explain these terms,
[the Wikipedia page](https://en.wikipedia.org/wiki/Manchester_code) is a good
place to start.

The data you will receive is not a secret

Staring points for each challenge can be found in the `/scaffolds` directory.

The pieces that are need in each challenge are:
* Read two pulses and convert them in to one binary bit.
* Read 8 bits and convert them in to a byte.
* Decode the `payload size` number.
* Read the correct amount of data from the source (according to payload size)
and check if it is correct.
* No exceptions should be raised ;)

Completed solutions can be found in the `/solutions` directory, so don't look at
anything in there unless you want spoilers!

Getting stuck on one particular part? The `/hints` directory contains snippets
of code to help get you past some of the hurdles so you don't get stuck. You can
look in there for help on things like:
  * Converting two pulses in to a bit.
  * Combining 8 bits in to a binary byte.
  * Converting a binary byte in to an integer a character.
  * Smoothing input errors to remove noise.

## How the data stream is formatted

Assuming you understand the basics of Manchester Coding, with regard to pulses
and frames and bits, here is how the data structured:

```ruby
0101010110100110 # Payload Size  (1 byte, 8 bits, 8 frames, or 16 pulses)
0110010110010101 # Payload Bytes (n-bytes, depending on *Payload Size*)
...              # ...
0101100110101001 # ...
```

The first byte you will receive is *payload size*. This is a number (integer)
which tells you how many completed bytes you can expect from the source. If you
try to read more data from the source than you should (like, the payload is 13
bytes long, but you try to read 14) and exception will be thrown.

Calling the `#read_signal` method will give you the next reading of the data
stream.

For these challenges, the decoded data is the same. Here is what's expected:

```ruby
# Binary  Decoded Pulses    Meaning  
00001101  0101010110100110  # The "payload size", which is the number of BYTES
                            # that will be send in this message. Here, our
                            # payload size will be 13 (an integer).
01001000  0110010110010101  # H
01100101  0110100101100110  # e
01101100  0110100110100101  # l
01101100  0110100110100101  # l
01101111  0110100110101010  # o
00101100  0101100110100101  # ,
00100000  0101100101010101  # <space>
01010111  0110011001101010  # W
01101111  0110100110101010  # o
01110010  0110101001011001  # r
01101100  0110100110100101  # l
01100100  0110100101100101  # d
00101110  0101100110101001  # .

#### Simple

Each pulse is represented by one character from the source, either "0" or "1".
Example:

```ruby
0101010110100110
```

#### Complicated

Each pulse is represented by a long run of zeros or ones, and each run will be
the same length. Example:

```ruby
00000111110000011111000001111100000111111111100000111110000000000111111111100000
```

#### Complex

The same data format as _Complicated_, but there will be small "errors" some
pulses (a single 1 in a run of 0s, etc), so you will need to look at the input
over time and smooth out these errors. . Example:

```ruby
00000111110010011111000001111100000111111101100000111110000000000111111111100000
#    Error: ^                      Error: ^
```

#### Complex-Plus

Same data format at _Complex_, but the length of some pulses may vary slightly
so your code will need to dynamically adjust its "clock" while the stream is
being read. Example:

```ruby
00000111110000011111000001111110000011111111110000011111000000000011111111100000
#        Variance (addition): ^           Variance (subtraction): ^
```

## How to check your results

You can check if your "payload" is correct by calling `#payload_correct?` and
passing the text your decoded at the argument. If it's correct, the method
will return `true`, otherwise it will return false.
