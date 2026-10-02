# Structs

```rust
// normal structs
struct User {
    active: bool,
    username: String,
    email: String,
    sign_in_count: u64,
}

// struct destructring
let user2 = User {
    email: String::from("another@example.com"),
    ..user1,
}

// struct tuples
struct Color(i32, i32, i32);
struct Point(i32, i32, i32);

let black = Color(0, 0, 0);
let origin = Point(0, 0, 0);
```

To be able to format these (for example, in a print statement), we need to use the `derive` macro:


```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}
```

## Associated Functions

All functions defined within an `impl` block are called associated funtions.

To define functions in the context of structs (i.e. methods), we start an `impl` block for the struct.

```rust
impl Rectangle {
    // use &mut self if we wnat to mutate state
    fn area(&self) -> u32 {
        self.width * self.height
    }
}
```

We can also define functions that don't have the `self` as the first parameter (and thus are not methods) - more like static methods. Commonly used for constructors that return a new instance of the struct.

```rust
impl Rectangle {
    fn square(size: u32) -> Self {
        Self {
            width: size,
            height: size,
        }
    }
}
```
