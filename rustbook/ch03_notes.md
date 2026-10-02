## Common Programming Concepts

Variables are immutable by default. Type can be inferred on assignment.

We can make them mutable by using the `mut` keyword:

```rust
let mut x = 0;
```

Constants can be set with the `const` keyword. They are always immutable (can't use `mut`) and can only be set to a constant expression. They must also always be type annotated.

```rust
const THREE_HOURS_IN_SECONDS: u32 = 60 * 60 * 3;
```

Shadowing variables is useful in rust - e.g. assigning a shadowed variable to use the same name with different types (ew).

```rust
// tuples
let tup: (i32, f64, u8) = (500, 6.4, 1);
let (x, y, z) = tup; // destructuring
let five_hundred = tup.0; // accessing

// arrays
let a: [i32; 5] = [1, 2, 3, 4, 5];
let b = [3; 5]; // expands to let b = [3, 3, 3, 3, 3];
let first = a[0]; // indexing (where is my tuple syntax? why is it diff????)
```

## Functions

You can return early from functions by using the `return` keyword and specifying a value, but most funtions return the last expression implicitly (that's lwk cursed).

## Control Flow

You can optionally specify loop label on a loop that you can then use with `break` or `continue` to specify that those keywords apply to the labeled loop instead of the innermost loop.

```rust
fn main() {
    let mut count = 0;
    'counting_up: loop {
        println!("count = {count}");
        let mut remaining = 10;

        loop {
            println!("remaining = {remaining}");
            if remaining == 9 {
                break;
            }
            if count == 2 {
                break 'counting_up;
            }
            remaining -= 1;
        }

        count += 1;
    }
    println!("End count = {count}");
}
```
