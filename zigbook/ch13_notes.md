# Filesystem and IO

## Input/Output Basics

The *standard output* and *standard input* channels of your OS are commonly known as the `stdout` and `stdin` channels of your OS, respectively.

## The Writer and Reader Pattern

In Zig, there is a pattern around input/output (IO). In essence, every IO operation in Zig is made through either a `Reader` or a `Writer` object.

These two data types are actually interfaces, and they come from the `std.Io` module of the Zig Standard Library.

## Using a default IO implementation

If you want to use some default IO implementation, there are currently three easy ways to quickly get an IO backend with default settings, which are:
- use the default IO implementation for the target configuration
- use a single threaded IO implementation with default configuration
- use the IO implementation from the `std.testing` module

### Using the IO implementation from `std.testing`

As the name suggests, the IO implementation from the `std.testing` module should be used only inside "unit tests context". If you try to use them inside any other type of context, you normally end up with a compilation error.

### Using the single threaded IO implementation

There is an easy and quick way to get a single threaded IO implementation. All you have to do is to instantiate a `std.Io.Threaded` object with the value `.init_single_threaded`, and then, call the `io()` method from the resulting object.

```zig
var threaded: std.Io.Threaded = .init_single_threaded;
const io = threaded.io();
_ = io;
```

### Using the default IO implementation for your target

You can use the `io` that comes from the `std.process.Init` object.

```zig
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    _ = stdout;
}
```

## Introducing File Descriptors

A "file descriptor" object is an identifier for a particular input/output (IO) resource from your OS. It describes and identifies this particular resource. An IO resource might be:
- an existing file in your filesystem
- an existing network socket
- other types of stream channels
- a pipeline (or just "pipe") in your terminal

A file descriptor not only identifies the input/output resource that you are using to receive or send some data, but it also describes where this resource is, and also, which IO mode this resource is currently using.

### `stdout`

We can use the `File.stdout()` function from the `std.Io` module. This function returns a file descriptor that describes the `stdout` channel of the current OS. Through this file descriptor object, we can read from or write stuff to the `stdout` of your program.

We normally only want write stuff into this channel, so when we access `File.stdout()`, most of the times, we also use the `writer()` method from the `stdout` file descriptor, to get access to a writer object that we can use to write stuff into this `stdout` channel.

```zig
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
}
```

In order to instantiate this writer object, we must provide a reference to a buffer object as input to the `writer()` method. By providing such buffer,we transform the IO operations performed by the `Writer` object into "buffered IO operations".

### `stdin`

You can access the *standard input* in Zig by using the `File.stdin()` function from the `std.Io` module. Like the buffer object, we also need to provide a reference to a buffer object as input to the `reader()` method, when instantiating our `Reader` object.

## Buffered IO

IO operations are made directly by the operating system. It's the OS that manages the IO resource that you want to use for your IO operations. The consequence of this fact is that IO operations are heavily based on system calls (i.e., calling the operating system directly).

System calls are fine to call once in a while but they are always orders of magnitude slower than many different types of operations.

### Understanding how buffered IO works

Buffered IO is a strategy to achieve better performance. It's used to reduce the number of system calls ade by IO operations, and, as consequence, achieve a much higher performance.

When we use a buffered IO system, at the first read operation we perform, instead of sending one single byte directly to our program, the OS first sends a chunk of bytes from the file to a buffer object. This chunk of bytes are cached/stored inside this buffer object.

Therefore, from now on, for every new read operation that you perform, instead of making a new system call to ask for the next byte in the file to the OS, this read operation is redirected to the buffer object, that have this next byte already cached.

The size of the buffer object depends on multiple factors. But it's usually equal to the size of a full page of memory (4096 bytes). If we follow this logic, then, the OS reads the first 4096 bytes of the file and caches it into the buffer object. As long as your program does not consume all of these 4096 bytes from the buffer, you will not create new system calls.

### Don't forget to flush

When you use buffered IO operations in your code, it is important to not forget to flush your buffers, specifically on write operations. Basically, when we are in a buffered IO scenario and we try to write data into "something", this data is first written into the IO buffer that we've provided to the `Writer` object as input, and this data in the IO buffer will only be effectively written into the "something" when we "commit" it. We "commit" the bytes written into the IO buffer to our target output by "flushing our IO buffer".

Thus, if you are writing data in Zig, don't forget to flush your IO buffers by calling the `flush()` method of your `Writer` object. This will make sure that the bytes/data that you are writing are effectively written into the IO resource described by your file descriptor object.

## Filesystem Basics

### `cwd`

The current working directory is the folder on your computer where you are currently rooted at.

### Concept of paths

A path is essentially a location. It points to a location in your filesystem. We use paths to describe the location of files and folders in our computer.

There are two types of paths that you can provide to any program in any OS: a relative path, or an absolute path. Absolute paths are paths that start at the root of your filesystem, and go all the way to the file name or the specific folder that you are referring to. A relative path is a path that start at the CWD.

## The CWD Handler

In Zig, filesystem operations are usually made through a directory handler object. A directory handler in Zig is an object of type `std.Io.Dir`, which is an object that describes a particular folder in the filesystem of our computer.
