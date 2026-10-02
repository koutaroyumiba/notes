# Generic Types, Traits, and Lifetimes

When defining a function that uses generics, we place the generics in the signature of the function where we would usually specify the data types of the parameters and return value.

```rust
// in functions
fn largest<T>(list: &[T]) -> &T {
    let mut largest = &list[0];
    for item in list {
        if item > largest {
            largest = item;
        }
    }

    largest
}

// structs and methods
struct Point<T> {
    x: T,
    y: T,
}

impl<T> Point<T> {
    fn x(&self) -> &T {
        &self.x
    }
}

// we can also specify
impl Point<f32> {
    fn distance_from_origin(&self) -> f32 {
        (self.x.powi(2) + self.y.powi(2)).sqrt()
    }
}
```

## Traits

A trait defines the functionality a particular type has and can share with other types. We can use trait bounds to specify that a generic type can be any type that has certain behaviour.

> A  bit similar to interfaces, but apparently has some differences.

```rust
// interface-like
pub trait Summary {
    fn summarize(&self) -> String;
}

// to implement, we need to be explicit:
pub struct NewsArticle { ... }

impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        format!("{}, by {} ({})", self.headline, self.author, self.location)
    }
}

// you can also define default implementations
pub trait Summary {
    fn summarize(&self) -> String {
        String::from("(Read more..._")
    }
}
// then we can just use:
impl Summary for NewsArticle {}
```

### Using traits as Parameters

```rust
pub fn notify(item: &impl Summary) {
    println!("Breaking news! {}", item.summarizer());
}
// above is equivalent to:
pub fn notify<T: Summary>(item: &T) {
    println!("Breaking news! {}", item.summarizer());
}

// we can also do multiple:
pub fn notify(item: &(impl Summary + Display)) { ... }
pub fn notify<T: Summary + Display>(item: &T) { ... }

// we can also use a where clause....??????
fn some_function<T: Display + Clone, U: Clone + Debug>(t: &T, u: &U) -> i32 { ... }
// is equivalent to
fn some_function<T, U>(t: &T, u: &U) -> i32
where T: Display + Clone, U: Clone + Debug,
{ ... }
```

### Using trait bounds to conditionally implement methods

You can also use trait buonds to conditionally implement methods which is pretty cool.

```rust
use std::fmt::Display;

struct Pair<T> {
    x: T,
    y: T,
}

impl<T> Pair<T> {
    fn new(x: T, y: T) -> Self {
        Self { x, y }
    }
}

impl<T: Display + PartialOrd> Pair<T> {
    fn cmp_display(&self) {
        if self.x >= self.y {
            println!("The largest member is x = {}", self.x);
        } else {
            println!("The largest member is y = {}", self.y);
        }
    }
}
```

You can also conditionally implement a trait for any type that implements another trait... That is pretty cool. These are called blanket implementations.

```rust
// implement ToString to any type that implements Display
impl<T: Display> ToString for T { ... }
```

## Lifetimes

Lifetime annotations don't change how long any of the references live. Rather, they descrive the relationships of the lifetimes of multiple references to each other without affecting the lifetimes.

```rust
// functions
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}

// structs
struct ImportantExcerpt<'a> {
    part: &'a str,
}
```

### Lifetime Elision

Rules that the compiler uses to infer lifetimes (lifetime annotations used to be more explicit).

1. the compiler assigns a lifetime parameter to each parameter that's a reference
2. if there is exactly one input lifetime parameter, that lifetime is assigned to all output lifetime parameters.
3. if there are multipel input lifetime parameters, but one of them is `&self` or `&mut self`, because this is a method, the lifetime of `self` is assigned to all output lifetime parameters.

### Static Lifetime

There is also a special lifetime called `'static` which denotes that the affected reference can live for the entire duration of the program. All string literals have the `'static` lifetime.
