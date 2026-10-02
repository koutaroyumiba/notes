# Automated Tests

Tests in rust are annotated with the `#[test]` attribute:

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_function() {
        // ... test goes here
    }
}
```

The `assert!` macro, provided by the standard library, is useful when you want to ensure that some condition in a test evaluates to `true`.

You can also use `assert_eq!()` and `assert_ne!`.

You can also add cstom failure messages by passing a format string that contains `{}` placeholders and values to go in those placeholders.

```rust
#[test]
fn greeting_contains_name() {
    let result = greeting("Carol");
    assert!(result.contains("Carol"), "Greetings did not contain name, value was `{result}`");
}
```

You can also check for panics with the `should_panic` attribute.

```rust
#[test]
#[should_panic]
fn greater_than_100() {
    Guess::new(200);
}
```

However, this will catch all panics - to be more specific: (the panic just needs to contain the expected string, not match)

```rust
#[test]
#[should_panic(expected = "less than or equal to 100")]
fn greater_than_100() {
    Guess::new(200);
}
```

We can also use `Result<T, E>` in tests which makes it helpful if we want to test functions that return `Err` (we can use `?`)

```rust
#[test]
fn it_works() -> Result<(), String> {
    let result = add(2, 2);

    if result == 4 {
        Ok(())
    } else {
        Err(String::from("two plus two does not equal four"))
    }
}
```

By default, if a test passes, Rust's test library captures anything printed to standard output. If you want to see printed values for passing tests as well, we can tell Rust to also show the output of successful with `--show-output`:

```bash
cargo test -- --show-output
```

You can also ignore tests unless specifically requested with the `ignore` attribute (useful for expensive tests).

```rust
#[test]
#[ignore]
fn expensive_test() {
    // ... code that takes an hour to run ...
}
```

```bash
cargo test                      # ignores the expensive test
cargo test -- --ignored         # runs just the ignored test
cargo test -- --include-ignored # runs all the tests
```

## Test Organization

### Unit Tests

Commonly colocated in the same file.

We use `#[cfg(test)]` annotation on the `tests` module tells Rust to compile and run the test code only when you run `cargo test` (not when you run `cargo build`).

### Integration Tests

We can create a `tests` directory at the top of our project directory, next to `src`. Cargo knows to look for integration test files in this directory.
