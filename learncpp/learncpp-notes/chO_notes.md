# Bit Manipulation
`std::bitset` provides 4 key member functions that are useful for doing bit manipulation:
- `test()` allows us to query whether a bit is 0 or 1
- `set()` allows us to turn a bit on (this will do nothing if the bit is already on)
- `reset()` allows us to turn a bit off (this will do nothing if the bit is already off)
- `flip()` allows us to flip a bit value from a 0 to a 1 or vice versa

Other useful member functions:
- `size()` returns the number of bits in the bitset
- `count()` returns the number of bits in the bitset that are set to `true`
- `all()` returns a Boolean indicating whether all bits are set to `true`
- `any()` returns a Boolean indicating whether any bits are set to `true`
- `none()` returns a Boolean indicating whether no bits are set to `true`


