# Functions

when a function is called, all of the parameters of the function are created as variables, and the value of each of the arguments is copied into the matching parameter (using copy initialization).
This process is called **pass by value**. Function parameters that utilize pass by value are called **value parameters**.

## Scope
variables defined inside the body of a function are called **local variables** (as opposed to *global variables*)

An identifier's **scope** determines where the identifier can be seen and used within the source code. When an identifier can bee seen and used, we say it is in scope.

## Forward Declaration

A **forward declaration** allows us to tell the compiler about the existence of an identifier before actually defining the identifier.
To write a forward declaration for a function, we use a **function declaration** statement (also called a **function prototype**). The function declaration consists of the function's return type, name, and parameter types, terminated with a semicolon. The names of the parameters can be optionally included. The function body is not included in the declaration.

```cpp
int add(int x, int y);
int add(int, int); // you can also declare like this
int main() { ... }
int add(int x, int y) { ... }
```

## The One Definition Rule (ODR)
The one definition rule (odr) is a well-known rule in C++. It consists of three parts:
1. within a file, each function, variable, type, or template in a given scope can only have one definition. Definitions occurring in different scopes (e.g., local variables defined inside different functions, or functions defined inside different namespaces) do not violate this rule.
2. within a program, each function or variable in a given scope can only have one definition. This rule exists because programs can have more than one file. Functions and variables not visible to the linker are excluded from this rule.
3. types, templates, inline functions, and inline variables are allowed to have duplicate definitions in different files, so long as each definition is identical.

- violating 1 will cause the compiler to issue a redefinition error
- violating 2 will cause the linker to issue a redefinition error
- violating 3 will cause undefined behaviour

## Multiple Code Files
The compiler compiles each file individually. It does not know about the contents of the other files, or remember anything it has seen from previously compiled code files. 

This limited visibility and short memory is intentional, for a few reasons:
1. it allows the source files of a project to be compiled in any order
2. when we change a source file, only that source file needs to be recompiled
3. it reduces the possibility of naming conflicts between identifiers in different files

# Namespaces
Most naming collisions occur in two cases:
1. two (or more) identically named functions (or global variables) are introduced into separate files belonging to the same program. This will result in a linker error
2. two (or more) identically named functions (or global variables) are introduced into the same file. This will result in a compiler error

A **scope region** is an area of source code where all declared identifiers are considered distinct from names declared in other scopes. Two identifiers with the same name can be declared in separate scope regions without causing a naming conflict. However, within a given scope region, all identifiers must be unique, otherwise a naming collision will result

A **namespace** provides another type of scope regoin (called **namespace scope**) that allows you to declare names inside of it for the purpose of disambiguation. The names declared in a namespace are isolated fro mnames declared in other scopes, allowing such names to exist without conflict.

In C++, any name that is not defined inside a class, function, or a namespace is considered to be part of an implicitly-defined namespace called the **global namespace**.
Notes:
- identifiers declared inside the global scope are in scope from the point of declaration to the end of the file
- although variables can be defined in the global namespace, this should generally be avoided

The `::` symbol is an operator called the **scope resolution operator**.
When an identifier includes a namespace prefix, the identifier is called a **qualified name**.

A **using directive** allows us to access the names in a namespace without using a namespace prefix.o

# Preprocessor
Prior to compilation, each code (.cpp) file goes through a preprocessing phase. In this phase, a program called the preprocessor makes various changes to the text of the code file. The preprocessor does not actually modify the original code files in any way - rather, all changes made by the preprocessor happen either temporarily in-memory or using temporary files.

When the processor has finished preprocessing a code file, the result is called a **translation** unit. This translation unit is what is then compiled by the compiler.

When you `#include` a file, the preprocessor replaces the `#include` directive with the contents of the included file. The included contents are then preprocessed (which may result in additional `#include`s being processed recursively), then the rest of the file is preprocessed.

## Macro Defines
The `#define` directive can be used to create a macro. In C++, a macro is a rule that defines how input text is converted into replacement output text.
There are two basic types of macros: *object-like macros* and *function-like macros*.
*Function-like macros* act like functions, and serve a similar purpose. Their use is generally considered unsafe, and almost anything they can do can be done by a normal function.
*Object-like macros* can be defined in one of two ways:
```cpp
#define IDENTIFIER
#define IDENTIFIER substitution_text
```
When a processor encounters object-like macros with substitution_text, an association is made between the macro identifier and substitution_text. All further occurrences of the macro identifier (outside of use in other preprocessor commands) are replaced by the substitution_text.

## Conditional Compilation
The conditional compilation preprocessor directives allow you to specify under what conditions something will or won't compile.
The `#ifdef` preprocessor directives allows the preprocessor to check whether an identifier has been previously defined via `#define`. If so, the code between the `#ifdef` and matching `#endif` is compiled. If not, the code is ignored.

One more common use of conditional compilation involves using `#if 0` to exclude a block of code from being compiled (as if it were inside a comment block)

# Header Files
When programs contain only a few small files, manually adding a few forward declarations to the top of each file isn't too bad. However, as programs grow larger (and make use of more files and functions), having to manually add a large number of (possibly different) forward declarations to the top of each file becomes extremely tedious.

Header files usually have a `.h` extension but can occassionally have a `.hpp` extension or no extension at all.
Conventionally, header files are used to propagate a bunch of related forward declarations into a code file.

Header files consist of two parts:
1. a header guard
2. the actual content of the header file, which should be the forward declarations for all of the identifiers we want other files to be able to see

Notes:
Use double quotes to include header files that you've written or are expected to be found in the current directory. Use angled brackets to include headers that come with your compiler, OS, or third-party libraries you've installed elsewhere on your system.

### Including header files from other directories 
For gcc:
`g++ -o main -I./source/includes main.cpp`

## Transitive includes
When your source (.cpp) file `#include`s a header file, you'll also get any other header files that are `#include`d by that header (and any header files those include, and so on). These additional header files are sometimes called **transitive includes**, as they're included implicitly rather than explicitly.

The content of these transitive includes are available for use in your code file. However, you should generally not rely on the content of the headers that are included transitively (unless reference documentation indicates that those transitive includes are required).

> **Best Practices** (ordering)
> To maximise the chance that missing includes will be flagged by the compiler, order your `#include`s as follows:
> - the paired header file for this code file
> - other headers from the same project
> - 3rd party library headers
> - standard library headers

> **General Best Practices for Header Files**
> - always include header guards
> - do not define variables and functions in header files
> - give a header file the same name as the source file it's associated with
> - each header file should have a specific job, and be as independent as possible
> - be mindful of which headers you need to explicitly include for the functionality that you are using in your code files, to avoid inadvertent transitive includes
> - a header file should `#include` any other headers containing functionality it needs
> - only `#include` what you need
> - do not `#include` `.cpp` files
> - prefer putting documentation on what something does or how to use it in the header

## Header Guards
We can avoid duplicate definitions via a mechanism aclled a **header guard** (also called an **include guard**). Header guards are conditional compilation directives that take the following form:
```cpp
#ifndef SOME_UNIQUE_NAME_HERE
#define SOME_UNIQUE_NAME_HERE
// your declarations here
#endif SOME_UNIQUE_NAME_HERE
```

When this header is `#include`d, the preprocessor will check whether `SOME_UNIQUE_NAME_HERE` has been previously defined in this translation unit. If this is the first time we're including the header, `SOME_UNIQUE_NAME_HERE` would not have been defined. Consequently, it `#defines` `SOME_UNIQUE_NAME_HERE` and includes the contents of the file. If the header is included again into the same file, `SOME_UNIQUE_NAME_HERE` will already have been defined from the first time the contents of the header were included, and the contents of the header will be ignored (thank to the `#ifndef`) 

All of your header files should have header guards on them. `SOME_UNIQUE_NAME_HERE` can be any name you want, but by convention is set to the full filename of the header file, typed in all caps, using underscores for spaces or punctuation. For example, `square.h` -> `SQUARE_H`
