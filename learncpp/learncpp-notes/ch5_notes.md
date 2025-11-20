# Constants
In programming, a **constant** is a value that may not be changed during the program's execution.
C++ supports two different kinds of constants:
- **named constants** are constant values that are associated with an identifier. These are also sometimes called **symbolic constants**
- **literal constants** are constant values that are not associated with an identifier

## Types of Named Constants
There are three ways to define a named constant in C++:
- constant variables
- object-like macros with substitution text
- enumerated constants

### Constant Variable

```cpp
// declaration
const double gravity{9.8};      // preferred use of const before type
int const sidesInSquare{4} ;    // "east const" style, okay but not preferred
```

Const variables must be initialized when you define them, and then that value can not be changed via assignment.
Note that const variables can be initialized from other variables (including non-const ones). 

#### Const Function Parameters
Function parameters can be made constants via the `const` keyword: `void printInt(const int x) { ... }`.

Making a function parameter constant enlists the compiler's help to ensure that the parameter's value is not changed inside the function. However, in modern C++ we don't make value parameters `const` because we generally don't care if the function changes the value of the parameter (since it's just a copy that will be destroyed at the end of the function anyway). The `const` keyword also adds a small amount of unnecessary clutter to the function prototype.

#### Const Return Values
A function's return value may also be made const: `const int getValue() { ... }`.

For fundamental types, the `const` qualifier on a return type is simply ignored. For other types, there is typically little point in returning const objects by value, because they are temporary copies that will be destroyed anyway. Returning a const value can also impede certain kinds of compiler optimizations (involving move semantics), which can result in lower performance.

#### NOTE:
If a variable can be made constant, it generally should be made constant. This is important for a number of reasons:
- it reduces the changes of bugs. By making a variable constant, you ensure that the value can't be changed accidentally
- it provides more opportunity for the compiler to optimize programs. When the compiler can assume a value isn't changing, it is able to leverage more techniques to optimize the program, resulting in a compiled program that is smaller and faster 
- more importantly, it reduces the overall complexity of our programs. When trying to determine what a section of code is doing or trying to debug an issue, we know that a const variable can't have its value changed, so we don't have to worry about whether its value is actually changing, what value it is changing to, and whether that new value is correct

### Object-like Macros with Substitution Text
For example:
```cpp
#include <iostream>
#define MY_NAME "Alex"
int main() {
    std::cout << "My name is: " << MY_NAME << '\n';
    return 0;
}
```

When the preprocessor processes the file containing this code, it will replace `MY_NAME` with `"Alex"`.

#### BUT prefer constant variables to preprocessor macros
Three major problems:
1. the biggest issue is that macros don't follow normal cpp scoping rules. Once a macro is #defined, all subsequent occurrences of the macro's name in the current file will be replaced. If that name is used elsewhere, you'll get macro substitution where you didn't want it. This will most likely lead to strange compilation errors.
2. it is often harder to debug code using macros. Although your source code will have the macro's name, the compiler and debugger never see the macro because it has already been replaced before they run.
3. macro substitution behaves differently than everything else in cpp. Inadvertent mistakes can be easily made as a result. 

### Type Qualifiers
A **type qualifier** (sometimes called *qualifier*) is a keyword that is applied to a type that modifies how that type behaves.
The `const` used to declare a constant variable is called a **const type qualifier**.
The `volatile` qualifier is used to tell the compiler that an object may have its value changed at any time. This qualifier disables certain types of optimizations.

# Literals
#### Digit Separators
Because long literals can be hard to read, C++14 adds the ability to use quotation mark `'` as a digit separator.
```cpp
int main() {
    int bin { 0b1011'0010 };
    int value { 2'132'673'462 };
}
```
Note that the separator cannot occur before the first digit of the value.

#### Outputting values in decimal, octal or hexadecimal
By default, C++ outputs values in decimal. However, you can change the output format via the use of the `std::dec`, `std::oct` and `std::hex` I/O manipulars:
```cpp
#include <iostream>

int main() {
    int x { 12 };
    std::cout << x << '\n';                 // decimal (default)
    std::cout << std::hex << x << '\n';     // hexadecimal
    std::cout << x << '\n';                 // now hexadecimal
    std::cout << std::oct << x << '\n';     // octal
    std::cout << std::dec << x << '\n';     // back to decimal
    return 0;
}
```

#### Outputting values in binary (`std::bitset`)
To use `std::bitset`, we can define a `std::bitset` variable and tell `std::bitset` how many bits we want to store. The number of bits must be a compile-time constant. `std::bitset` can be initialised with an integral value (in any format, including decimal, octal, hex, or binary).

```cpp
#include <bitset>   // for std::bitset
#include <iostream>

int main() {
    std::bitset<8> bin1 { 0b1100'0101 };
    std::bitset<8> bin2 { 0xC5 };

    std::cout << bin1 << '\n' << bin2 << '\n';
    std::cout << std::bitset<4>{ 0b1010 } << '\n';

    return 0;
}
```

# Constant Expressions
The use of language features that result in compile-time evaluation is called **compile-time programming**.
These features can help improve software in a number of areas:
- *performance*: compile-time evaluation makes our programs smaller and faster. The more code we can ensure is capable of evaluating at compile-time, the more performance benefit we'll see
- *versatility*: we can always use such code in places that require a compile-time value. Code that relies on the as-if rule to evaluate at compile-time can't be used in such places (eve if the compiler opts to evaluate that code at compile-time) --- this decision was made so that code that compiles today won't stop compiling tomorrow, when the compiler decides to optimize differently
- *predictability*: we can have the compiler halt compilation if it determines that code cannot be executed at compile-time (rather than silently opting to have that code evaluate at runtime instead). This allows us to ensure a section of code we really want to execute at compile-time will
- *quality*: we can have the compiler reliably detect certain kinds of programming errors at compile-time, and halt the build if it encounters them. This is much more effective than trying to detect and gracefully handle those same errors at runtime

A **constant expression** is a non-empty sequence of literals, constant variables, operators, and function calls, all of which must be evaluatable at compile-time. The key difference is that in a constant expression, each part of the expression must be evaluatable at compile-time.

Notably, the following cannot be used in a constant expression:
- non-const variables
- const non-integral variables, even when they have a constant expression initializer (e.g. `const double d { 1.2 };`). To use such variables in a constant expression, define them as `constexpr` variables instead  
- the return value of non-constexpr functions (even when the return expression is a constant expression)
- function parameters (even when the function is constexpr)
- operators with operands that are not constant expressions
- operators `new`, `delete`, `throw`, `typeid`, and `operator,` (comma)

An expression containing any of the above is a runtime expression

A **constexpr** variable is always a compile-time constant. As a result, a constexpr variable must be initialized with a constant expression, otherwise a compilation error will result.

### The meaning of const vs constexpr for variables
For variables:
- `const` means that the value of an object cannot be changed after initialization. The value of the initializer may be known at compile-time or runtime. The const object can be evaluated at runtime.
- `constexpr` means that the object can be used in a constant expression. The value of the initializer must be known at compile-time. The constexpr object can be evaluated at runtime or compile-time.

A **constexpr function** is a function that can be called in a constant expression. A constexpr function must evaluate at compile-time when the constant expression it is part of must evaluate at compile time (e.g. in the initializer of a constexpr variable). Otherwise, a constexpr function may be evaluated at either compile-time (if eligible) or runtime. To be eligible for compile-time execution, all arguments must be constant expressions.
To make a constexpr function, the `constexpr` keyword is placed in the function declaration before the return type.

# `std::string`
The easiest way to work with strings and string objects in C++ is via the `std::string` type, which lives in the `<string>` header.
```cpp
#include <string> // allows use of std::string

int main() {
    std::string name {};
    return 0;
}
```
One of the neatest things that `std::string` can do is store strings of different lengths.

To read a full line of input into a string, you're better off using `std::getline()` function instead of `std::cin`. `std::getline()` requires two arguments: the first is `std::cin` and the second is your string variable.
```cpp
#include <iostream>
#include <string>

int main() {
    std::cout << "Enter your full name: ";
    std::string name {};
    std::getline(std::cin >> std::ws, name); // read a full line of text into name

    return 0;
}
```
The `std::ws` input manipulator tells `std::cin` to ignore any leading whitespace before extraction. Leading whitespace is any whitespace character (spaces, tabs, newlines) that occur at the start of the string. This needs to be done for each `std::getline()` call, as `std::ws` is not preserved across calls.

### length of a `std::string`

```cpp
#include <iostream>
#include <string>

int main() {
    std::string name{ "Alex" };
    std::cout << name << " has " << name.length() << " characters\n";

    return 0;
}
```
Although `std::string` is required to be null-terminated, the returned length of a `std::string` does not include the implicit null-terminator character.

Note that `std::string::length()` returns an unsigned integral value (most likely of type `size_t`). If you want to assign the length of an `int` variable, you should `static_cast` it to avoid compiler warnings about signed/unsigned conversions.
`int length { static_cast<int>(name.length()) };`

Whenever a `std::string` is initialized, a copy of the string used to initialize it is made. Making copies of strings is expensive, so care should be taken to minimise the number of copies made.
When a `std::string` is passed to a function by value, the `std::string` function parameter must be instantiated and initialised with the argument. This results in an expensive copy, so we should use `std::string_view` instead.

Whenever a function returns by value to the caller, the return value is normally copied from the function back to the caller. However, as a rule of thumb, it is okay to return a `std::string` by value when the expression of the return statement resolves to any of the following:
- a local variable of type `std::string` 
- a `std::string` that has been returned by value from another function call or operator
- a `std::string` temporary that is created as part of the return statement
In most other cases, prefer to avoid returning a `std::string` by value, as doing so will make an expensive copy.

Double-quoted string literals are C-style strings by default (and thus, have a strange type).
We can create string literals with type `std::string` by using a `s` suffix after the double-quoted string literal. The `s` must be lowercase.

```cpp
#include <iostream>
#include <string>

int main() {
    using namespace std::string_literals // easy access to the s suffix
    std::cout << "foo\n";   // C-style string literal
    std::cout << "foo\n"s;  // std::string literal
    return 0;
}
```

# `std::string_view`
To address the issue with `std::string` being expensive to initialise (or copy), C++17 introduced `std::string_view` (which lives in the `<string_view>` header).
`std::string_view` provides read-only access to an *existing* string (a C-style string, a `std::string`, or another `std::string_view`) without making a copy. **Read-only** means that we can access and use the value being viewed, but we cannot modify it.

```cpp
#include <iostream>
#include <string>
#include <string_view>

void printSV(std::string_view str) {
    std::cout << str << '\n';
}

int main() {
    std::string_view s1 { "Hello, world!" }; // initialise with C-style string literal
    printSV("Hello, world!"); // call with C-style string literal

    std::string s{ "Hello, world!" };
    std::string_view s2 { s }; // initialise with std::string
    printSV(s); // call with std::string

    std::string_view s3 { s2 }; // initialise with std::string_view
    printSV(s3); // call with std::string_view

    return 0;
}
```

Because `std::string` makes a copy of its initialiser (which is expensive), C++ won't allow implicit conversion of a `std::string_view` to a `std::string`. This is to prevent accidentally passing a `std::string_view` argument to a `std::string` parameter, and inadvertently making an expensive copy where such a copy may not be required. 
However, if this is desired, we have two options:
1. Explicitly create a `std::string` with a `std::string_view` initialiser (which is allowed, since this will rarely be done unintentionally)
2. Convert an existing `std::string_view` to a `std::string` using `static_cast`

Assigning a new string to a `std::string_view` causes the `std::strinv_view` to view the new string. It does not modify the prior string being viewed in any way.

Double-quoted string literals are C-style string literals by default. We can create string literals with type `std::string_view` by using a `sv` suffix after the double-quoted string literal. The `sv` must be lowercase.

```cpp
#include <iostream>
#include <string>
#include <string_view>

int main() {
    using namespace std::string_literals;       // access the s suffix
    using namespace std::string_view_literals;  // access the sv suffix

    std::cout << "foo\n";
    std::cout << "foo\n"s;
    std::cout << "foo\n"sv;

    return 0;
}
```

Unlike `std::string`, `std::string_view` has full support for constexpr. This makes `constexpr std::string_view` the preferred choice when string symbolic constants are needed.

A view is dependent on the object being viewed. If the object being viewed is modified or destroyed while the view is still being used, unexpected or undefined behaviour will result.
A `std::string_view` that is viewing a string that has been destroyed is sometimes called a **dangling** view.

Some examples:
```cpp
// first example
std::string getName() {
    std::string s { "Alex" };
    return s;
}

int main() {
    std::string_view name { getName() };
    std::cout << name << '\n'; // undefined behaviour
    return 0;
}

// second example
int main() {
    using namespace std::string_literals;
    std::string_view name { "Alex"s };
    std::cout << name << '\n'; // undefined behaviour
    return 0;
}
```

Do not initialise a `std::string_view` with a `std::string` literal, as this will leave the `std::string_view` dangling.
It is okay to initialise a `std::string_view` with a C-style string literal or a `std::string_view` literal. It's also okay to initialise a `std::string_view` with a C-style string object, a `std::string` object, or a `std::string_view` object, as long as that string object outlives the view.

Invalidated objects can often be revalidated (made valid again) by setting them back to a known good state. For an invalidated `std::string_view`, we can do this by assigning the invalidated `std::string_view` object a valid string to view.

```cpp
#include <iostream>
#include <string>
#include <string_view>

int main() {
    std::string s { "Hello, world!" };
    std::string_view sv { s };  // sv is now viewing s

    s = "Hello universe!";      // modifies s, which invalidates sv (s is still valid)
    std::cout << sv << '\n';    // undefined behaviour

    sv = s;                     // revalidate sv; sv is now viewing s again
    std::cout << sv << '\n';    // prints "Hello universe!"

    return 0;
}
```

`std::string_view` can be used as the return value of a function. However, this is often dangerous.
Because local variables are destroyed at the end of the function, returning a `std::string_view` that is viewing a local variable will result in the returned `std::string_view` being invalid, and further use of that `std::string_view` will result in undefined behaviour.

There are two main cases where a `std::string_view` can be returned safely. First, because C-style string literals exist for the entire program, it's fine (and useful) to return C-style string literals from a function that has a return type of `std::string_view`.
Second, it is generally okay to return a function parameter of type `std::string_view`. However, if an argument is a temporary that is destroyed at the end of the full expression containing the function call, the returned `std::string_view` must be used immediately, as it will be left dangling after the temporary is destroyed.

- the `remove_prefix()` member function removes characters from the left side of the view
- the `remove_suffix()` member function removes characters from the right side of the view
```cpp
#include <iostream>
#include <string_view>

int main() {
    std::string_view str{ "Peach" };
    std::cout << str << '\n';   // Peach

    // remove 1 character from the left side of the view
    str.remove_prefix(1);
    std::cout << str << '\n';   // each

    // remove 2 characters from the right side of the view
    str.remove_suffix(2);
    std::cout << str << '\n';   // ea

    str = "Peach";
    std::cout << str << '\n';   // Peach

    return 0;
}
```

Once `remove_prefix()` and `remove_suffix()` have been called, the only way to reset the view is by reassigning the source string to it again.

# `std::string` vs `std::string_view`

### Variables
Use a `std::string` variable when:
- you need a string that you can modify
- you need to store user-inputted text
- you need to store the return value of a function that returns a `std::string`

Use a `std::string_view` variable when:
- you need read-only access to part or all of a string that already exists elsewhere and will not be modified or destroyed before use of the `std::string_view` is complete
- you need a symbolic constant for a C-style string
- you need to continue viewing the return value of a function that returns a C-style string or a non-dangling `std::string_view`

### Function Parameters
Use a `std::string` function parameter when:
- the function needs to modify the string passed in as an argument without affecting the caller
- you are using language standard C++14 or older and aren't comfortable using references

Use a `std::string_view` function parameter when:
- the function needs a read-only string
- the function needs to work with non-null-terminated strings

### Return Types
Use a `std::string` return type when:
- the return value is a `std::string` local variable or function parameter
- the return value is a function call or operator that returns a `std::string` by value

Use a `std::string_view` return type when:
- the function returns a C-style string literal or local `std::string_view` that has been initialised with a C-style string literal
- the function returns a `std:string_view` parameter

### Insights
Things to remember about `std::string`:
- initialising and copying `std::string` is expensive, so avoid this as much as possible
- avoid passing `std::string` by value, as this makes a copy
- if possible, avoid creating short-lived `std::string` objects
- modifying a `std::string` will invalidate any views to that string
- it is okay to return a local `std::string` by value

Things to remember about `std::string_view`:
- `std::string_view` is typically used for passing string function parameters and returning string literals
- because C-style string literals exist for the entire program, it is always okay to set a `std::string_view` to a C-style string literal
- when a string is destroyed, all views to that string are invalidated
- using an invalidated view (other than using assignment to revalidate the view) will cause undefined behaviour
- a `std::string_view` may or may not be null-terminated
