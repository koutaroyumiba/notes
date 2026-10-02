# Error Handling

Use the `panic!` macro for unrecoverable errors:

```rust
panic!("oh no...");
```

We can handle recoverable errors using `Result`:

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

Supports early return with the `?` operator (similar to `try` in Zig).

```rust
let greeting_file = File::open("hello.txt")?;
```
