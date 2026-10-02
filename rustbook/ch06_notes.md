# Enums and Pattern Matching

```rust
enum IpAddrKind {
    V4,
    V6,
}
let four = IpAddrKind::V4;
let six = IpAddrKind::V6;

// we can also do tagged unions :D
enum IpAddr {
    V4(u8, u8, u8, u8),
    V6(String),
}
let home = IpAddr::V4(String::from(127, 0, 0, 1));
let loopback = IpAddr::V6(String::from("::1"));
```

## Option Enum

```rust
enum Option<T> {
    None,
    Some(T),
}
```

## Match Control Flow

```rust
enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter,
}

fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => 1,
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter => 25,
    }
}

// we can also have default cases
match coin {
    Coin::Penny => 1,
    other => other,
}

// or don't use the item
match coin {
    Coin::Penny => 1,
    _ => println!("hi"),
}
```

## if let and let...else

```rust
let mut count = 0;
match coin {
    Coin::Quarter(state) => println!("what?!"),
    _ => count += 1,
}
// this can be turned into...
let mut count = 0;
if let Coin::Quarter(state) = coin {
    println!("what?!");
} else {
    count += 1;
}
```

You can also do the inverse (which is good for early returns)

```rust
fn describe_state_quarter(coin: Coin) -> Option<String> {
    if let Coin::Quarter(state) = coin {
        if state.existed_in(1900) {
            Some(format!("{state:?} is pretty old, for America!"))
        } else {
            Some(format!("{state:?} is relatively new."))
        }
    } else {
        None
    }
}
// this can be turned into...
fn describe_state_quarter(coin: Coin) -> Option<String> {
    let Coin::Quarter(state) = coin else {
        return None;
    }

    if state.existed_in(1900) {
        Some(format!("{state:?} is pretty old, for America!"))
    } else {
        Some(format!("{state:?} is relatively new."))
    }
}
```
