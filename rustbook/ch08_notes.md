# Common Collections

Will cover 3 common collections:
- **Vector** - allows you to store a variable number of values next to each other.
- **String** - collection of characters
- **HashMap** - allows you to associate a value with a specific key.

## Vectors

```rust
// creating a new vector
let v: Vec<i32> = Vec::new();
let v = vec![1, 2, 3]; // using a macro

// pushing to a vector
let mut v = Vec::new();
v.push(5);

// reading
let v = vec![1, 2, 3, 4, 5];
let third: &i32 = &v[2];
let third: Option<&i32> = v.get(2);

// interesting error (make sense if you think about dynamic array implementation)
let mut v = vec![1, 2, 3, 4, 5];
let first = &v[0];          // immutable borrow here
v.push(6);                  // mutation but immutable borrow still exists
println!("{first}");        // just so that first is in scope

// iterating
let mut v = vec![100, 32, 57];
for i in &v {
    println!("{i}");
}
for i in &mut v {
    *i += 50;
}
```

## String

```rust
// creating a new string
let mut s = String::new();
let s = "initial contents".to_string();
let s = String::from("initial contents");

// appending to strings
s.push_str("bar");
s.push('l'); // pushes one char

// string concatenation (ew operator overloading)
let s1 = String::from("hello ");
let s2 = String::from("world");
let s3 = s1 + &s2;

// we can also use the format! macro (does not take ownership of s1 or s2)
let s = format!("{s1}-{s2}");

// iterating
//  > strings are utf8 encoded so need to specify chars or bytes
for c in "utf8".chars() {
    println!("{c}");
}
for b in "utf8".bytes() {
    println!("{b}");
}
```

## HashMaps

```rust
use std::collections::HashMap;

let mut scores = HashMap::new();

// insert takes ownership
scores.insert(String::from("blue"), 10);
scores.insert(String::from("yellow"), 50);

let team_name = String::from("blue");
// get() -> Option<&i32>, copied() -> Option<i32>, unwrap_or() -> i32
let score = scores.get(&team_name).copied().unwrap_or(0);

// add a key, value only if key is not present
scores.entry(String::from("yellow")).or_insert(50);

// update based on old value
let text = "hello world wonderful world";
for word in text.split_whitespace() {
    let count = map.entry(word).or_insert(0);
    *count += 1;
}
```

By default, `HashMap` uses a hashing function called *SipHash*. You can specify a different hasher if you prefer. A hasher is a type that implements the `BuildHasher` trait.
