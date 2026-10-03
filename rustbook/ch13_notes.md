# Iterators and Closures

## Closures

Rust closures are anonymous functions you can save in a variable or pass as arguments to other functions.

Closures become 'concrete' from its first implementation:

```rust
let examalso ple_closure = |x| x;

let s = example_closure(String::from("hello"));
let n = example_closure(5);     // this will error
```

Closures can capture values from their environment in three ways, which directly map to the three ways a function can take a parameter: borrowing immutably, borrowing mutably, and taking ownership.

```rust
// borrows immutably
fn main() {
    let list = vec![1, 2, 3];
    println!("Before defining closure: {list:?}");              // [1, 2, 3]

    let only_borrows = || println!("From closure: {list:?}");

    println!("Before calling closure: {list:?}");               // [1, 2, 3]
    only_borrows();                                             // [1, 2, 3]
    println!("After calling closure: {list:?}");                // [1, 2, 3]
}

// borrows mutably
fn main() {
    let mut list = vec![1, 2, 3];
    println!("Before defining closure: {list:?}");      // [1, 2, 3]

    let mut borrows_mutably = || list.push(7);

    // immutable borrow to print isn't allowed :(
    borrows_mutably();
    println!("After calling closure: {list:?}");        // [1, 2, 3, 7]
}
```

If you want to force the closure to take ownership of the values it uses in the environment even though the body of the closure doesn't strictly need ownership, you can use the `move` keyword before the parameter list.

```rust
fn main() {
    let list = vec![1, 2, 3];
    println!("Before defining closure: {list:?}");

    thread::spawn(move || println!("From thread: {list:?}"))
        .join()
        .unwrap();
}
```

### Moving Captured Values out of Closures

Once a closure has captured a reference or captured ownership of a value from the environment where the closure is defined (thus, affecting what, if anything, is moved into the closure), the code in the body of the closure defines what happens to the references or values when the closure is evaluated later (thus, affecting what, if anything, is moved out of the closure).

A closure body can do any of the following: Move a captured value out of the closure, mutate the captured value, neither move nor mutate the value, or capture nothing from the environment to begin with.

Closures will automatically implement one, two, or all three of these `Fn` traits, in an additive fashion, depending on how the closure's body handles the values:

- `FnOnce` applies to closures that can be called once. All closures implement at least this trait because all closures can be called. A closure that moves captured values out of its body will only implement `FnOnce` and none of the other `Fn` traits because it can only be called once.
- `FnMut` applies to closures that don't move captured values out of their body but might mutate the captured values. These closures can be called more than once.
- `Fn` applies to closures that don't move captured values out of their body and don't mutate captured values, as well as closures that capture nothing from their environment. These closures can be called more than once without mutating their environment, which is important in cases such as calling a closure multiple times concurrently.

## Iterators

The iterator pattern allows you to perform some task on a sequence of items in turn. An iterator is responsible for the logic of iterating over each item and determining when the sequence has finished.

```rust
let v1 = vec![1, 2, 3];
let v1_iter = v1.iter();

for val in v1_iter {
    println!("Got: {val}");
}
```

All iterators implement a trait named `Iterator` that is defined in the standard library. The definition looks like this:

```rust
pub trait Iterator {
    type Item;

    fn next(&mut self) -> Option<Self::Item>;
}

#[test]
fn iterator_demo() {
    let v1 = vec![1, 2, 3];
    let mut v1_iter = v1_iter();

    assert_eq!(v1_iter.next(), Some(&1));
    assert_eq!(v1_iter.next(), Some(&2));
    assert_eq!(v1_iter.next(), Some(&3));
    assert_eq!(v1_iter.next(), None);
}
```

We need to make the `v1_iter` mutable because calling the `next` method on an iterator changes the internal state that the iterator uses to keep track of where it is in the sequence.

All values we get from the cals to `next` in th above example are immutable references to the values in the vector. The `iter` method produces an iterator over immutable references. `into_iter` produces an iterator that takes ownership of `v1` and returns owned values. `iter_mut` produces an iterator over mutable references.

### Methods that Consume the Iterator

Methods that call `next` are called *consuming adapters* because calling them uses up the iterator. One example is the `sum` method, which takes ownership of the iterator and iterates through the items by repeatedly calling `next`, thus consuming the iterator. We aren't allowed to use `v1_iter` after the call to `sum` because `sum` takes ownership of the iterator we call it on.

```rust
#[test]
fn iterator_sum() {
    let v1 = vec![1, 2, 3];
    let v1_iter = v1.iter();

    let total: i32 = v1_iter.sum();

    assert_eq!(total, 6);
}
```

### Methods that produce other Iterators

*Iterator adapters* are methods defined on the `Iterator` trait that don't consume the iterator. Instead, they produce different iterators by changing some aspect of the original iterator.

```rust
// example
let v1: Vec<i32> = vec![1, 2, 3];
v1.iter().map(|x| x + 1);
```
