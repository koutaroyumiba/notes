# Ownership

Ownership is the set of rules that govenr how a Rust program manages memory.

Rules:
- Each value in Rust has an owner.
- There can only be one owner at a time.
- When the owner goes out of scope, the value will be dropped.

```rust
fn main() {
    let s = String::from("hello");  // s comes into scope
    takes_ownership(s);             // s's value moves into the function
                                    // ... cannot access s here
}
```

Returning values can also transfer ownership.

Instead, you can provide references so that ownership is not transferred. We can also provide mutable references.

```rust
// immutable reference
fn calculate_length(s: &String) -> usize {}

// mutable reference
fn change(some_string: &mut String) {}
```

Mutables has the following restriction: If you have a mutable reference to a value, you can have no other references to that value.

## Slices

(why is slices here?!??! - I know why now)

Slices let you reference a contiguous sequence of elements in a collection. A slice is a kind of reference, so it does not have ownership.

A string slice is a reference to a contiguous sequence of the elements of a `String`.

```rust
let s = String::from("hello world");

let hello = &s[0..5];
let world = &s[6..11];
```
