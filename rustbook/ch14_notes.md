# Cargo and Crates.io

Cargo has two main profiles: the `dev` profile Cargo uses when you run `cargo build` and the `release` profile Cargo uses when you run `cargo build --release`.

We can run builds and tests for a particular crate in a workspace from the top-level directory by using the `-p` flag and specifying the name of the crate we want to build/test.

```bash
cargo test -p add_one
```

## Extending Cargo with Custom Commands

If a binary in your `$PATH` is named `cargo-something`, you can run it as if it were a Cargo subcommand by running `cargo something` - DATYUM
