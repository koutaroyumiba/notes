# Debugging in Zig

## Print Debugging

In the first argument of the `print` function, you specify a template string, and, in the second argument, you provide a list of values (or objects) that you want to insert into your template message.

Ideally, the template string in the first argument should contain some format specifier. Each format specifier is matched to a value (or object) that you have listed in the second argument. Each format specifier is represented by a single letter, and you provide this format specifier inside a pair of curly braces. Quick list of the most used format specifiers:

- `d`: for printing integers and floating-point numbers
- `c`: for printing characters
- `s`: for printing strings
- `p`: for printing memory addresses
- `x`: for printing hexadecimal values
- `any`: use any compatible format specifier (i.e., it automatically selects a format specifier for you)

## Debugging through Debuggers

In order to debug your program through a debugger, you must compile your source code in `Debug` mode. By compiling your source code in `Debug` mode, you ensure that the debugger will find the necessary information in your program to debug it. By default, the compiler uses the `Debug` mode when compiling your code.

First we compile the program with `zig build-exe`

```sh
zig build-exe add_program.zig

# start the debugger
lldb add_program

# breakpoint @ main
(lldb) b main
# run
(lldb) run
# go to next line
(lldb) n
# look at the value inside an object using p
(lldb) p <var>
# step inside a function using s
(lldb) s
# see the current variables in frame
(lldb) frame variable
```
