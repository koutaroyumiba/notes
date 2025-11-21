# Defining your own namespaces
C++ allows us to define our own namespaces via the `namespace` keyword. Namespaces that you create in your own programs are casually called `user-defined namespaces`.
The syntax for a namespace is as follows:
```cpp
namespace NamespaceIdentifier
{
    // content of namespace
}
```

If an identifier inside a namespace is used and no scope resolution is provided, the compiler will first try to find a matching declaration in that same namespace. If no matching identifier is found, the compiler will then check each containing namespace in sequence to see if a match is found, with the global namespace being checked last.

We can make use of the scope resolution operator `::` with no namespace (`::print()`) to explicitly call the global version of `print()`
```cpp
#include <iostream>

// print() in global namespace
void print() { 
    std::cout << " there\n";
}

namespace Foo {
// print() in Foo namespace
void print() {
    std:cout << "Hello";
}

void printHelloThere() {
    print();    // calls print() in Foo namespace
    ::print();  // calls print() in global namespace
}
}
```

# Linkage
An identifier's linkage determines whether other declarations of that name refer to the same object or not - local variables have no linkage.

Global variables and function identifiers can have eithher internal linkage or external linkage.

## Internal Linkage
An identifier with **internal linkage** can be seen and used within a single translation unit, but it is not accessible from other translation units. This means that if two source files have identically named identifiers with internal linkage, those identifiers will be treated as independent (and do not result in an ODR violation for having duplicate definitions).

To make a non-constant global variable internal, we use the `static` keyword.
Const and constexpr global variables have internal linkage by default (and thus don't need the `static` keyword).
```cpp
#include <iostream>

static int g_x{}; // non constant globals have external linkage by default
const int g_y{ 1 }; // const globals have internal linkage by default
constexpr int g_z{ 2 }; // const globals have internal linkage by default
```

Function identifiers also have linkage. Functions default to external linkage, but can be set to internal linkage via the `static` keyword.
Internal objects (and functions) that are defined in different files are considered to be independent entities (even if their names and types are identical), so there is no violation of the one-definition rule. Each internal object only has one definition.

### Why bother giving identifiers internal linkage?
There are typically two reasons to give identifiers internal linkage:
- there is an identifier we want to make sure isn't accessible to other files. This could be a global variable we don't want messed with, or a helper function we don't want to be called
- to be pedantic about avoiding naming collisions. Because identifiers with internal linkage aren't exposed to the linker, they can only collide with names in the same translation unit, not across the entire program

## External Linkage
An identifier with **external linkage** can be seen and used both from the file in which it is defined, and from other code files (via a forward declaration).
Identifiers with external linkage are visible to the linker. This allows the linker to do two things:
- connect an identifier used in one translation unit with the appropriate definition in another translation unit
- deduplicate inline identifiers so one canonical definition remains

Global variables with external linkage are sometimes called **external variables**. To make a global variable external (and thus accessible by other files), we can use the `extern` keyword to do so:
```cpp
int g_x{ 2 }; // non-constant globals are external by default

extern const int g_y{ 3 }; // const globals can be defined as extern, making them external
extern constexpr int g_z{ 3 }; // constexpr globals can be defined as extern, making them external
```

### Variable Forward Declaration
To actually use an external global global variable that has been defined in another file, you also must place a `forward declaration` for the global variable in any other files wishing to use the variable. For variables, creating a forward declaration is also done via the `extern` keyword (with no initialization value).
```cpp
extern int g_x;
extern const int g_y;
```

## `inline` keyword
In modern C++, the term `inline` has evolved to mean "multiple definitions are allowed". Thus, an inline function is one that is allowed to be defined in multiple translation units (without violating the ODR).
Inline functions have two primary requirements:
- the compiler needs to be able to see the full definition of an inline function in each translation unit where the function is used (a forward declaration will not suffice on its own). Only one such definition can occur per translation unit, otherwise a compilation error will occur
- the definition can occur after the point of use if a forward declaration is also provided. However, the compiler will likely not be able to perform inline expansion until it has seen the definition (so any uses between the declaration and definition will probably not be candidates for inline expansion)
- every definition for an inline function (with external linkage, which functions have by default) must be identical, otherwise undefined behaviour will result

The compiler needs to be able to see the full definition of an inline function wherever it is used, and all definitions for an inline function (with external linkage) must be identical (or undefined behaviour will result). The linker will consolidate all inline function definitions for an identifier into a single definition (thus still meeting the requirements of the one definition rule).

# Static Local Variables
Using the `static` keyword on a local variable changes its duration from automatic duration to static duration. This means the variable is now created at the start of the program, and destroyed at the end of the program (just like a global variable). As a result, the static variable will retain its value even after it goes out of scope.

Static local variables that are zero-initialised or have a constexpr initialiser can be initialised at program start.
Static local variables that have no initialiser or a non-constexpr initialiser are zero-initialised at program start. Static local variables with a non-constexpr initialiser are reinitialised the first time the variable is encountered. The definition is skipped on subsequent calls, so no further reinitialisation happens. Static local variables are used when you need a local variable to remember its value across function calls.

Static variables offer some of the benefit of global variables (they don't get destroyed until the end of the program) while limiting their visibility to block scope. This makes them easier to understand and safer to use.

Static local variables can be made const (or constexpr). One good use for a const static local variable is when you have a function that needs to use a const value, but creating or initialising the object is expensive (e.g. you need to read the value from a database).

# Summary
[scope, duration, linkage](https://www.learncpp.com/cpp-tutorial/scope-duration-and-linkage-summary/)

# `using` declarations and directives
A name can be either qualified or unqualified.
A **qualified name** is a name taht includes an associated scope. Most often, names are qualified with a namespace using the scope resolution operator (`::`).
An **unqualified name** is a name that does not include a scoping qualifier.

## Using-declarations
One way to reduce the repetition of typing `std::` over and over is to utilise a using-declaration statement. A **using declaration** allows us to use an unqualified name (with no scope) as an alias for a qualified name.

```cpp
#include <iostream>

int main() {
    using std::cout;
    cout << "Hello world!\n"; // no std:: prefix needed here

    return 0;
} // using declaration expires at the end of the current scope
```

The using-declaration is active from the point of declaration to the end of the scope in which it is declared.
Although using-declarations are less explicit than using the `std::` prefix, they are generally considered safe and acceptable to use in source files, with one exception.

## Using-directives
Another way to simplify things is to use a using-directive. A **using directive** allows *all* identifiers in a given namespace to be referenced without qualification from the scope of the using-directive. (e.g. `using namespace std;`)

In modern C++, using-directives generally offer little benefit (saving some typing) compared to the risk. This is due to two factors:
1. using-directives allow unqualified access to *all* of the names from a namespace (potentially including lots of names you'll never use)
2. using-directives do not prefer names from the namespace identified by the using-directive over other names

## Scope of using-statements
If a using-declaration or using-directive is used within a block, the names are applicable to just that block (it follows normal block scoping rules).
If a using-declaration or using-directive is used in a namespace (including the global namespace), the names are applicable to the entire rest of the file (they have file scope).

## Do not use using-statements in header files, or before #include directive 
A good rule of thumb is that using-statements should not be placed anywhere where they might have an impact on code in a different file. Nor should they be placed anywhere where another file's code might be able to impact them.

# Unnamed and inline namespaces
An **unnamed namespace** (also called an anonymous namespace) is a namespace that is defined without name.
```cpp
#include <iostream>

namespace {
    void doSomething() {
        std::cout << "v1\n";
    }
}
```

All content declared in an unnamed namespace is treated as if it is part of the parent namespace.
This may make unnamed namespaces seem useless but the other effect of unnamed namespaces is that all identifiers inside an unnamed namespace are treated as if they have internal linkage, which means that the content of an unnamed namespace can't be seen outside of the file in which the unnamed namespace is defined.
For functions, this is effectively the same as defining all functions in the unnamed namespace as static functions.

Unnamed namespaces are typically used when you have a lot of content that you want to ensure stays local to a given translation unit, as it's easier to cluster such content in a single unnamed namespace than individually mark all declarations as `static`. Unnamed namespaces will also keep program-defined types local to the translation unit, something for which there is no alternative equivalent mechanism to do so. 
Avoid unnamed namespaces in header files.

An **inline namespace** is a namespace that is typically used to version content. Much like an unnamed namespace, anything declared inside an inline namespace is considered part of the parent namespace. However, unlike unnamed namespaces, inline namespaces don't affect linkage.

To define an inline namespace, we use the `inline` keyword:
```cpp
#include <iostream>

// declare an inline namespace named V1
inline namespace V1 {
    void doSomething() {
        std::cout << "V1\n";
    }
}

// declare a normal namespace named V2
namespace V2 {
    void doSomething() {
        std::cout << "V2\n";
    }
}

int main() {
    V1::doSomething();  // calls the V1 version
    V2::doSomething();  // calls the V2 version
    doSomething();      // calls the inline version (V1)

    return 0;
}
```
