# Bits and Byte)
The smallest unit of memory is a binary digit (also called a bit) which can hold a value of 0 or 1.
A byte is a group of bits that are operated on as a unit. The modern standard is that a byte is comprised of 8 sequential bits.

# Types

## Integer/Integral Types
The C++ standard defines the following terms:
- the **standard integer types** are `short`, `int`, `long`, `long long` (including their signed and unsigned variants)
- the **integral types** are `bool`, the various `char` types and the standard `integer` types

> Note: the `_t` suffix
> Many of the types defined in newer versions of C++ (e.g., `std::nullptr_t`) use a `_t` suffix. This suffix means "type", and it's a common nomenclature applied to modern types

## Void Type
`void` is our first example of an incomplete type. An **incomplete type** is a type that has been declared but not yet defined. The compiler knows about the existence of such types but does not have enough information to determine how much memory to allocate for objects of that type. `void` is intentionally incomplete since it represents the lack of a type, and thus cannot be defined.

## Object Sizes
The C++ standard does not define the exact size (in bits) of any of the fundamental types.
Instead, the standard says the following:
- an object must occupy at least 1 byte (so that each object has a distinct memory address)
- a byte must be at least 8 bits
- the integral types `char`, `short`, `int`, `long`, and `long long` have a minimum size of 8, 16, 16, 32, and 64 bits respectively
- `char` and `char8_t` are exactly 1 byte (at least 8 bits)

| type | min. size | typical size |
| --- | --- | --- |
| `bool` | 1 byte | 1 byte |
| `char` | 1 byte (exactly) | 1 byte |
| `wchar_t` | 1 byte | 2 or 4 bytes |
| `char8_t` | 1 byte | 1 byte |
| `char16_t` | 2 bytes | 2 bytes |
| `char32_t` | 4 bytes | 4 bytes |
| `short` | 2 bytes | 2 bytes |
| `int` | 2 bytes | 4 bytes |
| `long` | 4 bytes | 4 or 8 bytes |
| `long long` | 8 bytes | 8 bytes |
| `float` | 4 bytes | 4 bytes |
| `double` | 8 bytes | 8 bytes |
| `long double` | 8 bytes | 8, 12 or 16 bytes |
| `std::nullptr_t` | 4 byte | 4 or 8 bytes |

### `sizeof` Operator
In order to determine the size of data types on a particular machine, C++ provides an operator named `sizeof`. The **sizeof operator** is a unary operator that takes either a type or a variable and returns the size of an object of that type (in bytes).

## Signed Integer
C++ has 4 primary fundamental integer types available for use - `short int`, `int`, `long int`, `long long int`
By default, integers in C++ are **signed**, which means the number's sign is stored as part of the value.

We call the set of specific values that a data type can hold its **range**. The range of an integer variable is determined by two factors: its size (in bits) and whether it is signed or not.
An $n$-bit signed variable has a range of $-(2^{n - 1})$ to $(2^{n - 1}) + 1$ (assuming two's complement)

### Overflow
C++20 standard makes this blanket statement:
"If during the evaluation of an expression, the result is not mathematically defined or not in the range of representable values for its type, the behaviour is undefined". Colloquially, this is called overflow.

## Unsigned Integer 
Unsigned integers are integers that can only hold non-negative whole numbers.
To define an unsigned integer, we use the `unsigned` keyword. By convention, this is placed before the type:
```cpp
unsigned short us;
unsigned int ui;
unsigned long ul;
unsigned long long ull;
```

An $n$-bit unsigned variable has a range of 0 to $(2^n) - 1$
If an unsigned value is out of range, the mod of the value when divided by the max number will be kept.

### Controversy (what?!)
Many developers believe that developers should generally avoid unsigned integers. This is largely because of two behaviours that can cause problems:
1. with signed values, it takes a little work to accidently overflow the top or bottom of the range because those values are far from 0. With unsigned numbers, it is much easier to overflow the bottom of the range, because the bottom of the range is 0, which is close to where the majority of our values are
2. unexpected behaviour can result when you mix signed and unsigned integers. In C++, if a mathematical operation (e.g. arithmetic or comparison) has one signed integer and one unsigned integer, the signed integer will usually be converted to an unsigned integer. And the result will thus be unsigned (WHAT?!).
```cpp
// example 1
unsigned int u{2};
signed int u{3};

std::cout << u - s << '\n'; // 2 - 3 = 4294967295 <- what

// example 2
signed int s{-1};
unsigned int u{1};

if (s < u) std::cout << "fail"; // -1 => 4294967295 so 4294967295 < 1 is false
else std::cout << "pass";
```

Then when should you use unsigned integers?
1. unsigned integers are preferred when dealing with bit manipulation. They are also useful when well-defined wrap-around behaviour is required (useful in some algorithms like encryption and random number generation)
2. use of unsigned integers is still unavoidable in some cases, mainly those having to do with array indexing
3. if you're developing for an embedded system or some other processor/memory limited context, use of unsigned numbers is more common and accepted for performance reasons

## Fixed Width Integers
The fixed-width integers are defined (in the `<cstdint>`/header) as follows:
```cpp
std::int8_t x;
std::uint8_t x;
std::int16_t x;
std::uint16_t x;
std::int32_t x;
std::uint32_t x;
std::int64_t x;
std::uint64_t x;
```

Note: due to an oversight (rip) in the C++ specification, modern compilers typically treat `std::int8_t` and `std::uint8_t` (and the corresponding fast and least fixed-width types) the same as `signed char` and `unsigned char` respectively. 

The fixed-width integers have some potential downsides:
1. the fixed-width integers are not guaranteed to be defined on all architectures. They only exist on systems where there are fundamental integral types that match their widths and following a certain binary representation. Your program will fail to compile on any such architecture that does not support a fixed-width integer that your program is using. However, given that modern architectures have standardized around 8/16/32/64-bit variables, this is unlikely to be a problem unless your program needs to be portable to some exotic mainframe or embedded architectures.
2. if you use a fixed-width integer, it may be slower than a wider type on some architectures. For example, if you need an integer that is guaranteed to be 32-bits, you might decide to use `std::int32_t`, but your CPU might actually be faster at processing 64-bit integers.

### Fast and Least Integral Types
The fast types (`std::int_fast#_t` and `std::uint_fast#_t`) provide the fastest signed/unsigned integer type with a width of at least # bits (where # = 8, 16, 32, or 64). For example, `std::int_fast32_t` will give you the fastest signed integer type that's at least 32-bits. By fastest, we mean the integral type that can be processed most quickly by the CPU.
The least types (`std::int_least#_t` and `std::uint_least#_t`) provide the smallest signed/unsigned integer type with a width of at least # bits (where # = 8, 16, 32, or 64). For example, `std::uint_least32_t` will give you the smallest unsigned integer type that's at least 32-bits.

Best practice:
- prefer `int` when the size of the integer doesn't matter (e.g. the number will always fit within the range of a 2-byte signed integer)
- prefer `std::int#_t` when storing a quantity that needs a guaranteed range
- prefer `std::uint#_t` when doing bit manipulation or well-defined wrap-around behaviour is required
Avoid the following when possible:
- `short` and `long` integers (prefer a fixed-width integer type instead)
- the fast and least integral types (prefer a fixed-width integer type instead)
- unsigned types for holding quantities (prefer a signed integer type instead)
- the 8-bit fixed-width integer types (prefer a 16-bit fixed-integer type instead)
- any compiler-specific fixed-width integers

## `std::size_t`
`sizeof` returns a value of type `std::size_t` - alias for an implementation-defined unsigned integral type.

The size of `std::size_t` imposes a strict mathematical upper limit on an object's size. In practice, the largest creatable object may be smaller than this amount (perhaps significantly so).
Some compilers limit the largest creatable object to half the maximum value of `std::size_t`.
Other factors may also play a role, such as how much contiguous memory your computer has available for allocation. 

## Floating Point Numbers
C++ has three fundamental floating point data types - `float`, `double`, `long double`.
On modern architectures, floating-point types are conventionally implemented using one of the floating-point formats defined in the IEEE 754 standard.

When using floating point literals, always include at least one decimal place (even if the decimal is 0). This helps the compiler understand that the number is a floating point number and not an integer.
Note that by default, floating point literals default to type `double`. An `f` suffix is used to denote a literal of type float.

The **precision** of a floating point type defines how many significant digits it can represent without information loss. 
The number of digits of precision a floating point type has depends on both the size and the particular value being stored.

### `NaN` and `Inf`
IEEE 754 compatible formats additionally support some special values:
- `Inf` which represents infinity. `Inf` is signed and can be positive (`+Inf`) or negative (`-Inf`)
- `NaN` which stands for "Not a number". There are several different kinds of `NaN`
- signed 0, meaning there are separete representations for "positive 0" and "negative 0"
Formats that are not compatible with IEEE 754 may not support some (or any) of these values. In such cases, code that uses or generates these special values will produce implementation-defined behaviour.

## Boolean Values
Boolean variables are variables hat can have only two possible values: `true` or `false`.
When we print boolean variables, it prints 1 for `true` and 0 for `false` (bools are integral types) - if you want `std::cout` to print `true` or `false`, we can output `std::boolalpha` (`std::cout << std::boolalpha`) (`std::noboolalpha` to turn off).

## Chars
The `char` data type was designed to hold a single `character`. The `char` data type is an integral type, the integer stored by a `char` variable are interpreted as an `ASCII character`.
**ASCII* stands for American Standard Code for Information Interchange, and it defines a particular way to represent English characters (plus a few other symbols) as numbers between 0 and 127 (called an **ASCII code** or **code point**).

Code 0-31 and 127 are called the unprintable chars. These codes were designed to control peripheral devices such as printers. Most of these are now obsolete.
Code 32-126 are called the printable characters and they represent the letters, number characters, and punctuation that most computers use to display basic English text.

Note: if we want to extract the whitespace in input (don't want to ignore the leading whitespace), use `std::cin.get()`
```cpp
std::cin >> ch;     // will ignore leading whitespace
std::cin.get(ch);   // will not ignore leading whitespace
```

`char` is defined by C++ to always be 1 byte in size. By default, a `char` may be signed or unsigned (though it's usually signed).

### Escape Sequences
There are some sequences of characters in C++ that have special meaning. These characters are called **escape sequences**.

| name | symbol | meaning |
| --- | --- | --- |
| alert | `\a` | makes an alert, such as a beep |
| backspace | `\b` | moves the cursor back one space |
| formfeed | `\f` | moves the cursor to next logical page |
| newline | `\n` | moves cursor to next line |
| carriage return | `\r` | moves cursor to beginning of line |
| horizontal tab | `\t` | prints a horizontal tab | 
| vertical tab | `\v` | prints a vertical tab |
| single quote | `\'` | prints a single quote |
| double quote | `\"` | prints a double quote |
| backslash | `\\` | prints a backslash |
| question mark | `\?` | prints a question mark (no longer relevant) |
| octal number | `\(number)` | translates into char represented by octal |
| hex number | `\x(number)` | translates into char represented by hex |

## Type Conversion and Static Cast
The process of converting data from one type to another type is called **type conversion**.
When the compiler does type conversion on our behalf without us explicitly asking, we call this **implicit type conversion**.

### Type conversion of a value produces a new value
The type conversion process does not modify the value (or object) supplying the data to be converted. Instead, the conversion process uses that data as input, and produces the converted result.

Some type conversions (such as a `char` to an `int`) always preserve the value being converted, whereas others (such as `double` to `int`) may result in the value being changed during conversion. Unsafe implicit conversions will typically either generate a compiler warning, or (in the case of brace initialization) an error.

### Explicit Type Conversion via the `static_cast` operator
Explicit type conversion allow us (the programmer) to explicitly tell the compiler to convert a value from one type to another type, and that we take full responsibility for the result of that conversion. If such a conversion results in the loss of value, the compiler will not warn us.
To perform an explicit type conversion, in most cases we'll use the `static_cast` operator.
Syntax: `static_cast<new_type>(expression)`
`static_cast` takes the value from an expression as input, and returns that value converted into the type specified by `new_type`.

### Sign Conversions using `static_cast`
Signed integral values can be converted to unsigned integral values, and vice versa, using a static cast.
If the value being converted can be represented in the destination type, the converted value will remain unchanged (only the type will change). 
If the value being converted cannot be represented in the destination type:
- if the destination type is unsigned, the value will be modulo wrapped
- if the destination type is signed, the value is implementation-defined prior to C++20, and will be modulo wrapped as of C++20
