# Control Flow, Structs, Modules, Types

## Control Flow

```zig
// if statements
if (condition) {
    // condition = true
} else {
    // condition = false
}

// switch statements
switch (role) {
    .PM => {
        // handle this condition
    },
    .KS => {
        // handle stuff
    },
    else => // default case
}

// you can also assign
const category = switch (level) {
    1, 2 => "beginner",
    3 => "professional",
    else => {
        @panic("not supported level!");
    }
};
// you can also use ranges (... operator makes both ends inclusive)
const category = switch (level) {
    0...25 => "beginner",
    26...75 => "intermediate",
    76...100 => "professional",
    else => {
        @panic("not supported level");
    },
};
```

### The `defer` keyword

The `defer` keyword in Zig allows you to register an expression to be executed when you exit the current scope.
This is different from the `defer` keyword in Go which always move an expression to be executed at the **exit of the current function**.

### The `errdefer` keyword

While `defer` is an "unconditional defer", the `errdefer` keyword is a "conditional defer". Which means that the given expression is executed only when you exit the current scope on a very specific circumstance.

### Loops

```zig
// for loops
const name = "Pedro";
for (name, 0..) |_, i| {
    print("{d} | ", .{i});
}

// while loops
var i: u8 = 1;
while (i < 5) {
    print("{d} | ", .{i});
    i += 1;
}

// while loops with continue statement
var i: u8 = 1;
while (i < 5) : (i += 1) {
    print("{d} | ", .{i});
}
```

## Immutability of Function Parameters

Function arguments are immutable in Zig.

If a function argument receives as input an object whose data type is any of the primitive types, the object is always passed by value to the function. However, if the input object has a more complex data type, the `zig` compiler will take the liberty of deciding which strategy is best (the `zig` compiler will pass the object to the function either by value, or by reference). This optimization is possible because function parameters are immutable.

You can overcome the immutability by using a pointer. The pointer itself will become constant (you cannot change the memory address that it points to) but you can dereference the pointer to access the value that it points to and change its value.

## Structs

In Zig, we normally declare the constructor and the destructor methods of our structs, by declaring an `init()` and `deinit()` methods inside the struct.

### Struct declarations must be constant

Types in Zig must be `const` or `comptime`. What this means is that you cannot create a new data type, and mark it as variable with the `var` keyword. So always declare with the `const` keyword.

### The `self` method argument

The `self` argument is the reference to the object itself from which the method is being called from. If we have a method that alters the values of its data members, we should annotate `self` as a pointer of `x`, instead of just `x`.

```zig
const Vec3 = struct {
    // fields here...

    pub fn readonly(self: Vec3) { ... }
    pub fn mutates(self: *Vec3) { ... }
}
```

## Type Inference

In general, type inference in Zig is done by using the dot character (`.`). Everytime you see a dot character written before a struct literal, or before an enum value, or something like that, you know that this dot character is playing a special part in this place (similar to `auto` in cpp).

## Type Casting

In Zig, we can use the `@as()` builtin function to cast an object of type `x` into an object of type `y`. To use this function, you just provide the target data type in the first argument, and, the object that you want cast as the second argument. However, this function only works when casting is unambiguous and safe.

If these assumptions do not hold, we need to use specialized "casting functions". For example, if you want to cast an integer value into a float value, then you should use the `@floatFromInt()` function.

Another builtin function that is very useful when performing type casting operations is `@ptrCast()`. In essence, we use the `@as()` builtin function when we want to explicit convert (or cast) a Zig value/object from a type `x` to a type `y`, etc. However, pointers are a special type of object in Zig.

## Modules

Every Zig module (i.e., a `zig` file) that you write in your project is internally stored as a struct object.
