# Concept
## Seed function
Initilization random generator with a positive integer r
1. Timer to generate a random value, but Timer not implemented in SPIM (only MARS)
2. Use stack pointer and multiply by n

## uint32_t rand()
Formula rn = (a\*rn-1+b) mod m
For a 32bit CPU the following values could be chosen:
a = 1103515245, b = 12345, m = 2^(31) = 2147483648

## int frand() between 0.0 and 1.0
idea scaling rand
the 32bit value consists of sign bit, 8 bit exponent and a 23 bit fraction/mantissa
value = (-1)^s x 1.f x 2(e-b) for single precision bias b = 127
- The sign bit is always 0 since rand should return positive  value between 0.0 and 1.0

One idea to perform it is to make a floating point division:
rand (0 to 2^(31)-1) divided by MAX_RANDOM (2^31) ranges between 0.0 and 1.0

1. Save MAX_RANDOM value in data section as flaoting point value
2. Generate rand and convert it to floating point number
3. Perform division rand() / MAX_RANDOM
