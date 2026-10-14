# Build System

## `build()` function

A build script in Zig always contains a public (and top-level) `build()` function declared. The `build()` function should accept a pointer to a `Build` object as input, and it should use this "build object" to perform the necessary steps to build your project.

```zig
const std = @import("std");
pub fn build(b: *std.Build) void{
    ...
}
```

## Target Objects

Each target object is normally a binary file (or an output) that you want to get from the current process. You can list multiple target objects in your build script, so that the build process generates multiple binary files for you at once.

## Linking to External Libraries

In Zig, there are two notions of a "library", which are 1. a system library; 2. a local library. A system's library is just a library that is already installed in your system. While a local library is a library that belongs to the current project; a library that is present in your project directory, and that you are building together with your project source code.

The basic difference between the two is that a system's library is already built and installed in your system, and all you need to do is link your source code to this library to start using it. We do that by using the `linkSystemLibrary` method from a `Compile.root_module` object.

## Building C code

The `zig` compiler comes with a `C` compiler embedded in it. In other words, you can use the `zig` compiler to build `C` projects. This `C` compiler is available through the `cc` command of the `zig` compiler.

### Creating C compiler flags

Compiler flags are also known as "compiler options" by many programmers, or also as "command options" in the GCC official documentation.

In build scripts written in Zig, we normally list the C compiler flags to be used in the compilation process in a simple array:

```zig
const c_flags = [_][]const u8{
    "-Wall",
    "-Wextra",
    "-Werror",
};
```
