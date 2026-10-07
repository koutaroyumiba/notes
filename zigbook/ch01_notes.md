# Introduction to Zig

In Zig, we don't need to use a separate set of tools to build our projects, because a build system is embedded inside the language itself.

In Zig, there are three types of comments that you can write in your code:
- normal comments, which are lines that start with `//` and are completely ignored by the compiler
- doc comments, which are lines that start with `///`, and they document the variable/type/whatever immediately follows that comment. These comments are used by the compiler to generate documentation for your code.
- top-level doc comments, which are lines that start with `//!`, and are always present at the top of the Zig module, and are used by the compiler to generate documentation about the entire module

## Creating New Objects in Zig

### Declaring without an Initial Value

By default, when you declare a new object in Zig, you must give it an initial value. In other words, this means that we have to declare, and, at the same time, initialize every object we create in our source code.

You can explicitly initialize things to be `undefined`.

```zig
var age: u8 = undefined;
age = 25;
```

Every time you declare a new object in Zig, you have two choices:

1. you either use the value of this object;
2. you explicitly discard the value of the object using `_`;

When you assign a particular object to the underscore, this object is essentially destroyed. It's discarded by the compiler. This means that you can no longer use this object further in your code.

```zig
const age = 15;
_ = age;
std.debug.print("{d}\n", .{age + 2});   // does not compile - pointless discard
```

### You must mutate every `var` object

Every `var` object you create in your source code must be mutated at some point, otherwise compiler is angry. This is SUPER nice imo.

## Arrays

All elements present in an array in Zig must have the same data type.

```zig
const ns = [4]u8{48, 24, 12, 6};
const ls = [_]f64{432.1, 87.2, 900.05};     // [_] infers the length
```

These are static arrays.

You can use `[]` syntax for indexing. You can also select specific slices of your array, by using a range selector with the syntax `start..end (not inclusive)`.

```zig
const ar = [4]u8{48, 24, 12, 6};
const sl = ar[0..ar.len];       // {48, 24, 12, 6}, equivalent to ar[..]
_ = sl;
```

A slice object is essentially a pointer object (`[*]T`) accompanied by a length number (`usize`). The pointer object points to the first element in the slice, and the length number tells the `zig` compiler how many elements there are in this slice.

### Array Operators

There are two array operators available in Zig. The array concatenation operator (`++`) and the array multiplication operator (`**`). These operators only work when both operands have a size that is compile-time known.

```zig
const a = [_]u8{1, 2, 3};
const b = [_]u8{4, 5};
const c = a ++ b;       // { 1, 2, 3, 4, 5 }

const a = [_]u8{1, 2, 3};
const c = a ** 2;       // { 1, 2, 3, 1, 2, 3 }
```

## Blocks and Scopes

You can define blocks using `{}` and the variables defined in each block is scoped to that block (normal scoping rules). You can also add labels to blocks and specify what to return from that block with `break`.

```zig
var y: i32 = 123;
const x = add_one: {
    y += 1;
    break :add_one y;
};
if (x == 124 and y == 124) {
    try stdout.print("Hey!", .{});
    try stdout.flush();
}
```

## Strings

A string in Zig is essentially an array of arbitrary bytes, or more specifically, an array of `u8` values. Zig always assumes that the sequence of bytes in strings is UTF-8 encoded (you can use `iconv` if it uses a different encoding). So you can do stuff like this:

```zig
const bytes = [_]u8{ 0x48, 0x65, 0x6C, 0x6C, 0x6F };
try stdout.print("{s}\n", .{bytes});        // Hello
try stdout.flush();
```

### Using slice vs sentinel-terminated array

There are two different ways string are used and accessed inside Zig code:
- a sentinel-terminated array of `u8` values
- a slice of `u8` values

With sentinel-terminated array, you embed both the length of the array, and also, the sentinel value in the type itself of your object. These are represented as `*const [n:0]u8`. The `n` in the type indicates the size of the string and the zero after the `n:` part is the sentinel value itself.

### Iterating through the string

You can use a `for` loop to iterate through each byte in the string.

```zig
for (string_object) |byte| {
    // do stuff with byte here
}
```

### Object Types

To check the type of any object in Zig, you can use the `@TypeOf()` function.

### Byte vs Unicode

Byte and Unicode does not have a 1-1 relationship, a unicode character can be encoded with more than one byte. Therefore, if you need to iterate through the characters of a string, instead of its bytes, then, you can use the `std.unicode.Utf8View` struct to create an iterator that iterates through the unicode points of your string.

```zig
var utf8 = try std.unicode.Utf8View.init("america");
var iterator = utf8.iterator();
while (iterator.nextCodepointSlice()) |codepoint| {
    try stdout.print("got codepoint {x}\n", .{codepoint});
}
try stdout.flush();
```

### Useful Functions for Strings

- `std.mem.eql()`: to compare if two strings are equal
- `std.mem.splitScalar()`: to split a string into an array of substrings given a delimiter value
- `std.mem.splitSequence()`: to split a string into an array of substrings given a substring delimiter
- `std.mem.startsWith()`: to check if string starts with subtring
- `std.mem.endsWith()`: to check if string ends with substring
- `std.mem.trim()`: to remove specific values from both start and end of the string
- `std.mem.concat()`: to concatenate strings together
- `std.mem.count()`: to count the occurrences of substring in the string
- `std.mem.replace()`: to replace the occurrences of substring in the string

## Safety in Zig

The tools listed below are related to memory safety:

- `defer` allows you to keep free operations physically close to allocations
- `errdefer` helps you to guarantee that your program frees the allocated memory, even if a runtime error occurs
- pointers and objects are non-nullable by default (BIG)
- Zig offers native types of allocators (called "testing allocators") that can detect memory leaks and double-frees
- arrays and slices in Zig have their length embedded in the object itself, which makes the `zig` compiler very effective in detecting out-of-bound indexes and avoiding buffer overflows
