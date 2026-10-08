# base64 encoder/decoder

Base64 is an encoding system which translates binary data to text.

The base64 encoding system is based on a scale that goes from 0 to 63. The scale is as follows:
- range 0 to 25 is represented by: ASCII uppercase letters `-> [A-Z]`;
- range 26 to 51 is represented by: ASCII lowercase letters `-> [a-z]`;
- range 52 to 61 is represented by: one digit numbers `-> [0-9]`;
- index 62 and 63 are represented by `+` and `/`, respectively;
- the character `=` represents the end of meaningful characters in the sequence (not actually part of the scale itself);

## base64 encoder

The algorithm behind a base64 encoder usually works on a window of 3 bytes (24 bits). One character in a base64 encoding scale is takes 6 bits. Therefore, the base64 algorithm works by converting 3 bytes at a time into 4 characters from the base64 scale.

Problem: What if you have a particular string that has a number of bytes that is not divisible by 3 - what happens?

We still try to decode but: when we have a 6-bit group that is not completely full, extra zeros are added to fill the gap. When an entire 6-bit group is empty, or simply doesn't exist, that group becomes a padding group. Every "padding group" is mapped to the character `=`, which represents "null".

### Encoding Logic

There are 3 different scenarios that we need to take into account for the transformation.
1. the perfect scenario, where we have the perfect window of 3 bytes
2. we have a window of only two bytes to work with
3. we have a window of one single byte

Case 1 (3 bytes):
1. `output[0]` is produced by moving the bits from `input[0]` two positions to the right
2. `output[1]` is produced by summing two components. First, take the last two bits from `input[0]`, then move them four positions to the left. Second, move the bits from `input[1]` four positions to the right. Sum these two components.
3. `output[2]` is produced by summing two components. First, take the last four bits from `input[1]`, then, move them two positions to the left. Second, move the bits from `input[2]` six positions to the right. Sum these two components.
4. `output[3]` is produced by taking the last six bits from `input[2]`

Case 2 (2 bytes):
1. same as Case 1
2. same as Case 1
3. `output[2]` is produced by taking the last 4 bits from `input[1]`, then, move them two positions to the left
4. `output[3]` is the character `=`

Case 3 (1 byte):
1. same as Case 1
2. `output[1]` is produced by taking the last two bits from `input[0]`, then, move them four positions to the left
3. `output[2]` and `output[3]` are the character `=`

## base64 decoder

Each byte in the output string of the decoder (the original binary data) is normally created from two different bytes in the input (the base64 encoded data). In other words, each byte that comes out of a base64 decoder is created by tranforming (or merging) two different bytes in the input together.

First, we take each base64 encoded character from the input, and we convert it back to its corresponding index in the base64 scale. Then, we apply a series of transformations over these indexes to produce the original bytes of the message.

The steps to decode are:
1. `output[0]` is produced by summing two components. First, move the bits from `buf[0]` two positions to the left. Second, move the bits from `buf[1]` 4 positions to the right. Then, sum these two components.
2. `output[1]` is produced by summing two components. First, move the bits from `buf[1]` four positions to the left. Second, move the bits from `buf[2]` 2 positions to the right. Then, sum these two components.
3. `output[2]` is produced by summing two components. First, move the bits from `buf[2]` six positions to the left. Then, you sum the result with `buf[3]`
