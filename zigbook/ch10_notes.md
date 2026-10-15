# Error Handling and Unions

An error is actually a value in Zig. In other words, when an error occurs inside your Zig program, it means that somewhere in your Zig codebase, an error value is being generated. An error value is similar to any integer value that you create in your Zig code. You can take an error value and pass it as input to a function, and you can also cast (or coerce) it into a different type of an error value.

However, error values in Zig are treated very differently than exceptions. First, you cannot ignore error values in your Zig code. Meaning that, if an error value appears somewhere in your source code, this error value must be explicitly handled in some way. This also means that you cannot discard error values by assigning them to an underscore, as you could do with normal values and objects.

## Error Sets

When you have a function that can return different types of errors, you can list all of these different types of errors that can be returned from this function, through a structure in Zig that we call of an *error set*.

An error set is a special case of an union type. It's a union that contains error values in it. It's a convenient way of grouping a set of possible error values into a single object, or a single type of an error value.

## Casting Error Values

If error set `A` is a superset of error set `B`, then, you can cast (or coerce) error values from `B` into error values of `A`.

Error sets are just a set of error values. So, if the error set `A` contains all error values from the error set `B`, then `A` becomes a superset of `B`.

## Handling Errors

### `try`

When you use the `try` keyword in an expression, you are telling the `zig` compiler to execute the expression and if it returns an error, propagate the error up the call stack (return the error).

### `catch`

With `catch`, we can construct a block of logic to handle the error value, in case it happens in the current expression.

```zig
const file = cwd.openFile(init.io, "doesnt_exist.txt", .{}) catch |err| {
    logger.record_context();
    logger.log_error(err);
    return err;
};
```

You can also use `catch` to handle the error in a "default value" style. That is, if the expression returns an error, we use the default value instead. Otherwise, we use the valid value returned by the expression.

```zig
const number = parseU64(str, 10) catch 13;
```

### Using `if` statements

You can also ues if statements to handle errors in your Zig code.

```zig
if (parseU64(str, 10)) |number| {
    // do something with `number` here
} else |err| {
    // handle the error value
}
```

### `errdefer`

A common pattern in C program in general, is to clean resources when an error occurs during the execution of the program of the program. In other words, one common way to handle errors, is to perform "cleanup actions" before we exit out program. This guarantees that a runtime error does not make our program to leak resources of the system.

The basic idea is to provide an expression to the `errdefer` keyword. Then, `errdefer` executes this expression if and only if, an error occurs during the execution of the current scope.

```zig
fn create_user(db: Datebase, allocator: Allocator) !User {
    const user = try allocator.create(User);
    errdefer allocator.destroy(user);

    _ = try db.register_user(user);
    return user;
}
```

By using `errdefer` to destroy the `user` object that we have just created, we guarantee that the memory allocated for this `user` object gets freed, before the execution of the program stops. If you allocate and free some memory for an object inside the same scope, then, just use `defer` and be happy. But if you allocate some memory in a scope A, but you only free this memory later, in a scope B for example, then, `errdefer` becomes useful to avoid leaking memory in sketchy situations.
