# Pointers and Optionals

## Types of Pointers

In Zig, there are two types of pointers, which are:
- single-item pointer (`*`)
- many-item pointer (`[*]`)

Single-item pointer objects are objects whose data types are in the format `*T`. In contrast, many-item pointers are objects whose data types are in the format `[*]T`. When you apply the `&` operator over an object, you will always get a single-item pointer. Many-item pointers are more of a "internal type" of the language, more closely related to slices.

## Optionals and Optional Pointers

### Null Handling in Optionals

When you have an optional object in your Zig code, you have to explicitly handle the possibility of this object being null. We can do that, by using either:
- an if statement
- the `orelse` keyword
- unwrap the optional value with the `?` method

```zig
// i love this syntax btw
const num: ?i32 = 5;
if (num) |not_null_num| {
    try stdout.print("{d}\n", .{not_null_num});
    try stdout.flush();
}

// this is okay
const x: ?i32 = null;
const dbl = (x orelse 15) * 2;
try stdout.print("{d}\n", .{dbl});
try stdout.flush();

// .? = orelse unreachable
const x: i32 = null;
try stdout.print("{d}\n", .{x.?}); // explosion

// i lwk thought this is like .? with errors where it propagates
```
