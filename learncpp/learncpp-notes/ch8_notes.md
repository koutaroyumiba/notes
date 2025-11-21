# Constexpr if statements
C++17 introduces the **constexpr if statement**, which requires the conditional to be a constant expression. The conditional of a constexpr-if-statement will be evaluated at compile-time.
If the constexpr conditional evaluates to `true`, the entire if-else will be replaced by the true-statement. If the constexpr conditional evaluates to `false`, the entire if-else will be replaced by the false-statement. (if it exists) or nothing (if there is no else).
To use a constexpr-if-statement, we add the `constexpr` keyword after the `if`:
```cpp
#include <iostream>

int main() {
    constexpr double gravity{ 9.8 };
    if constexpr (gravity == 9.8) {
        std::cout << "gravity is normal.\n";
    } else {
        std::cout << "we are not on earth.\n";
    }

    return 0;
}
```

# Switch statements
The idea behind a switch statement is simple: an expression is evaluated to produce a value. Then one of the following occurs:
- if the expression's value is equal to the value after any of the case-labels, the statements after the matching case-label executed
- if no matching value can be found and a default label exists, the statements after the default label are executed
- if no matching value can be found and there is no default label, the switch is skipped

The condition/expression in a switch must evaluate to an integral type of an enumerated type.

Each set of statements underneath a label should end in a break-statement or a return-statement. This includes the statements underneath the last label in the switch.

## Fallthrough
When a switch expression matches a case label or optional default label, execution begins at the first statement following the matching label. Execution will then continue sequentially until one of the following termination conditions happens:
- the end of the switch block is reached
- another control flow statement (typically a `break` or `return`) causes the switch block or function to exit
- something else interrupts the normal flow of the program

When execution flows from a statement underneath a label into statements underneath a subsequent label, this is called **fallthrough**.

# Global Random Numbers (`Random.h`)
See file `../ch8/Random.h` for a header-only solution that can be #included in any code file that needs a randomised, self-seeded `std::mt19937`.


