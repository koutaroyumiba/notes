# initialization
From `./main.cpp`

```cpp
  // 5 common forms of initialization in cpp:
  int a;     // default-initialization
  int b = 5; // copy-initialization (initial value after =)
  int c(6);  // direct-initialization (initial value in paren)
  int d{7};  // direct-list-initialization (initial value in braces)
  int e{};   // value-initialization (empty braces)
```

### List-initialization disallows narrowing conversions
One of the primary benefits of list-initialization is that "narrowing conversions" are disallowed.

```cpp
int w1{4.5}; // compilation error - list-init does not allow narrowing
int w2 = 4.5; // compiles - w2 copy-initialized to 4
int w3(4.5); // compiles - w3 direct-initialized to 4
```

When a variable is initialized using an empty set of braces, a special form of list-initialization takes place. In most cases, value-initialization will implicitly initialize the value to zero (or whatever value is closest to 0 for a given type). In cases where zeroing occurs, this is called zero-initialization.

# input/output library

```cpp
#include <iostream>

int main() {
    std::cout << "Hi!" << std::endl;
    return 0;
}
```

## `std::cout`
Example usage: `std::cout << "Hello World!";`

### Note: `std::cout` is buffered
Statements in our program request that output be sent to the console. However, that output is typically not sent to the console immediately. Instead, the requested output "gets in line", and is stored in a region of memory set aside to collect such requests (called a **buffer**). Periodically, the buffer is **flushed**, meaning all of the data collected in the buffer is transferred to its destination (in this case, the console).

Using `std::endl` is often inefficient as it actually does two jobs: it outputs a newline and it flushes the buffer. If we output multiple lines of text ending with `std::endl`, we will get multiple flushes, which is slow and probably unnecessary.

When outputting text to the console, we typically don't need to explicitly flush the buffer ourselves. C++'s output system is designed to self-flush periodically, and it's both simpler and more efficient to let it flush itself.

To output a newline without flushing the output buffer, we can use `\n`.

## `std::cin`
Example usage: `std::cin >> x;`

### Note: `std::cin` is buffered
Similar to `std::cout`, inputting data is also a two stage process:
- the individual characters you enter as input are added to the end of an input buffer (inside `std::cin`). The enter key (pressed to submit the data) is also stored as a `\n` character)
- the extraction operator `>>` removes characters from the front of the input buffer and converts them into a value that is assigned (via copy-assignment) to the associated variable. 

The basic extraction process:
1. if `std::cin` is not in a good state (e.g. the prior extraction failed and `std::cin` has not yet been cleared), no extraction is attempted, and the extraction process aborts immediately
2. leading whitespace characters (spaces, tabs, and newlines at the front of the buffer) are discarded from the input buffer. This will discard an unextracted newline character remaining from a prior line of input
3. if the input buffer is now empty, operator `>>` will wait for the user to enter more data. Any leading whitespace is discarded from the entered data
4. operator `>>` then extracts as many consecutive characters as it can, until it encounters either a newline character (representing the end of the line of input) or a character that is not valid for the variable being extracted to

The result of the extraction process is as follows:
- if the extraction aborted in step 1, then no extraction attempt occurred. Nothing else happens.
- if any characters were extracted in step 4 above, extraction is a success. The extracted characters are converted into a value that is then copy-assigned to the variable.
- if no characters could be extracted in step 4 above, extraction has failed. The object being extracted to is copy-assigned the value 0 (as of C++11) and any future extractions will immediately fail (until `std::cin` is cleared)

Any non-extracted characters (including newlines) remain available for the next extraction attempt.
