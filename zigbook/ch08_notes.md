# Testing

## Testing Memory Allocations

When developing your source code, you, the programmer, are responsible for making sure that your code does not produce memory problems. However, you can also use a special type of an allocator object that is capable of automatically detecting such problems for you. This is the `std.testing.allocator` object. This allocator object offers some basic memory safety detection features, which are capable of detecting memory leaks.

## Testing Errors

You can use the `expectError()` function, from the `std.testing` module. With this function, you can test if a specific function call returns the exact type of error that you expect it to return.
