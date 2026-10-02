# Packages, Crates and Modules

- **Packages**: A cargo feature that lets you build, test, and share crates
- **Crates**: A tree of modules that produces a library or executable
- **Modules and use**: Let you control the organization, scope, and privacy paths
- **Paths**: A way of naming an item, such as a struct, function, or module

```rust
mod front_of_house {
    pub mod hosting {
        fn add_to_waitlist() {}
    }
}
```

We can use the `use` keyword to bring a path to scope.

```rust
use crate::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
}
```

We can also alias `use` variables into scope:

```rust
use std::fmt::Result;
use std::io::Result as IoResult;

fn function1() -> Result {}
fn function2() -> IoResult<()> {}
```

`use` is kind of like `import` in other languages.

```rust
use std::cmp::Ordering;
use std::io;
// can be shortened to:
use std::{cmp::Ordering, io};

use std::io;
use std::io::Write;
// ...into...
use std::io::{self, Write};

// theres also glob
use std::collections::*
```
