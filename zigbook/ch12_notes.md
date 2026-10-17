# Building Stack

## Understanding `comptime` in Zig

There are three ways in which you can apply the `comptime` keyword, which are:
- apply `comptime` on a function argument
- apply `comptime` on an object
- apply `comptime` on a block of expressions

### Apply over a function argument

When you apply the `comptime` keyword on a function argument, you are saying to the `zig` compiler that the value assigned to that particular function argument must be known at compile time.

Comptime arguments are frequently used on functions that return some sort of generic structure. In fact, `comptime` is the essence to make generics in Zig.

### Apply over an expression/block

When you apply the `comptime` keyword over an expression, then, it is guaranteed that the `zig` compiler will execute this expression at compile time. If for some reason, this expression cannot be executed at compile-time, then, the `zig` compiler will raise a compilation error.

When you apply the `comptime` keyword to a block of expressions, you get essentially the same effect as when you apply this keyword to a single expression. That is, the entire block of expressions is executed at compile-time by the `zig` compiler.

## Introducing Generics

Generics can be made in Zig, using `comptime T: type` as a function parameter:

```zig
fn max(comptime T: type, a: T, b: T) T { ... }
```
