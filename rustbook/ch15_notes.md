# Smart Pointers

The most common smart pointers in the standard library:

- `Box<T>`, for allocating values on the heap
- `Rc<T>`, a reference counting type that enables multiple ownership
- `Ref<T>` and `RefMut<T>`, accessed through `RecCell<T>`, a type that enforces the borrowing rules at runtime instead of compile time.

## `Box<T>`

*Boxes` allow you to store data on the heap rather than the stack. Boxes don't have performance overhead, other than storing their data on the heap instead of on the stack. Use them most often in these situations:

- When you have a type whose size can't be known at compile time, and you want to use a value of that type in a context that requires an exact size
- When you have a large amount of data, and you want to transfer ownership but ensure that the data won't be copied when you do so
- When you want to own a value, and you care only that it's a type that implements a particular trait rather than being of a specific type

## `Deref`

*Deref coercion* converts a reference to a type that implements the `Deref` trait into a reference to another type. For example, deref coercion can convert `&String` to `&str` because `String` implements the `Deref` trait such that it returns `&str`.
`Deref` trait overrides the `*` operator on immutable references, `DerefMut` trait overrides the `*` operator on mutable references.

Rust does deref coercion when it finds types and trait implementations in three cases:
1. From `&T` to `&U` when `T: Deref<Target=U>`
2. From `&mut T` to `&mut U` when `T: DerefMut<Target=U>`
3. From `&mut T` to `&U` when `T: Deref<Target=U>`

## `Drop`

`Drop` lets you customize what happens when a value is about to go out of scope. The trait requires you to implement one method named `drop` that takes in a mutable reference to `self`. You are not allowed to manually call `drop`, if you want to force the cleanup early, you need to use `std::mem::drop`.

## `Rc<T>`

When you want to have multiple ownership, you can enable it explicitly by using `Rc<T>`, which is an abbreviation for *reference counting*. The `Rc<T>` type keeps track of the number of references to a value to determine whether or not the value is still in use. If there are zero references to a value, the value can be cleaned up without any references becoming invalid.

## `RefCell<T>` and the Interior Mutability Pattern

*Interior Mutability* is a design pattern in Rust that allows you to mutate data even when there are immutable references to that data; normally, this action is disallowed by the borrowing rules. To mutate data, the pattern uses `unsafe` code inside a data structure to bend Rust's usual rules that govern mutation and borrowing.

### Enforcing Borrowing Rules at Runtime

Unlike `Rc<T>`, the `RefCell<T>` type represents single ownership over the data it holds (similar to `Box<T>`). With references and `Box<T>`, the borrowing rules' invariants are enforced at compile time. With `RefCell<T>`, these invariants are enforced at runtime.

The advantage of checking the borrowing rules at runtime instead is that certain memory-safe scenarios are then allowed, where they would've been disallowed by the compile-time checks. Some properties of code are impossible to detect by analyzing the code.

Similar to `Rc<T>`, `RefCell<T>` is only for use in single-threaded scenarios and will give you a compile-time error if you try using it in a multithreaded context.

Recap of the reasons to choose `Box<T>`, `Rc<T>`, or `RefCell<T>`:
- `Rc<T>` enables multiple owners of the same data; `Box<T>` and `RefCell<T>` have single owners;
- `Box<T>` allows immutable or mutable borrows checked at compile time, `Rc<T>` allows only immutable borrows checked at compile time, `RefCell<T>` allows immutable or mutable borrows checked at runtime;
- Because `RefCell<T>` allows mutable borrows checked at runtime, you can mutate the value inside the `RefCell<T>` even when the `RefCell<T>` is immutable;

When creating immutable and mutable references, we use the `&` and `&mut` syntax respectively. With `RefCell<T>`, we use the `borrow` and `borrow_mut` methods. The `borrow` method returns the smart pointer type `Ref<T>` and `borrow_mut` returns the smart pointer type `RefMut<T>`. Both types implement `Deref`, so we can treat them like regular references.

The `RefCell<T>` keeps track of how many `Ref<T>` and `RefMut<T>` smart pointers are currently active. Every time we call `borrow`, the `RefCell<T>` increases its count of how many immutable borrows are active. When a `Ref<T>` value goes out of scope, the count of immutable borrows goes down by 1. `RefCell<T>` lets us have many immutable borrows or one mutable borrows at any point in time.

### Allowing Multiple Owners of Mutable Data

A common way to use `RefCell<T>` is in combination with `Rc<T>`. If we have an `Rc<T>` that holds a `RefCell<T>`, you can get a value that can have multiple owners and that you can mutate.

## Reference Cycles can Leak Memory

Rust allows memory leaks by using `Rc<T>` and `RefCell<T>`: it's possible to create references where items refer to each other in a cycle.

Creating reference cycles is not easily done, but it's not impossible either. If you have `RefCell<T>` values that contain `Rc<T>` values or similar nested combinations of types with interior mutability and reference counting, you must ensure that you don't create cycles; you can't rely on Rust to catch them.

### Preventing Reference Cucles Using `Weak<T>`

Calling `Rc::clone` increases the `strong_count` of an `Rc<T>` instance, and an `Rc<T>` instance is only cleaned up if its `strong_count` is 0. You can also create a weak reference to the value within an `Rc<T>` instance by calling `Rc::downgrade` and passing a reference to the `Rc<T>`.

Strong references are how you can share ownership of an `Rc<T>` instance. Weak references don't express an ownership relationship, and their count doesn't affect when an `Rc<T>` instance is cleaned up. They won't cause a reference cycle, because any cycle involving some weak references will be broken once the strong reference count of values involved is 0.

When you call `Rc::downgrade`, you get a samrt pointer of type `Weak<T>`. Instead of increasing the `strong_count` in the `Rc<T>` instance by 1, calling `Rc::downgrade` increases the `weak_count` by 1. The `Rc<T>` type uses `weak_count` to keep track of how many `Weak<T>` references exist, similar to `strong_count`. The difference is the `weak_count` doesn't need to be 0 for the `Rc<T>` instance to be cleaned up.

Because the value that `Weak<T>` references might have been dropped, to do anything with the value that a `Weak<T>` is pointing to you must make sure the value still exists. Do this by calling the `upgrade` method on a `Weak<T>` instance, which will return an `Option<Rc<T>>`. You'll geet a result of `Some` if the `Rc<T>` value has not been dropped yet and a result of `None` if it has.

