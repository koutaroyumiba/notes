# Exponentiation

To do exponents in C++, `#include` the `<cmath>` header, and use the `pow()` function:
```cpp
#include <cmath>

double x { std::pow(3.0, 4.0) };
```

If you want to do integer exponentiation, you're best off using your own function to do so:
```cpp
#include <cassert> // for assert
#include <cstdint> // for std::int64_t

constexpr std::int64_t powint(std::int64_t base, int exp) {
    assert(exp >= 0 && "powint: exp parameter has negative value");

    // handle 0 case
    if (base == 0) {
        return (exp == 0) ? 1 : 0;
    }

    std::int64_t result{ 1 };
    while (exp > 0) {
        if (exp & 1) {
            // if exp is odd
            result *= base;
        }
        exp /= 2;
        base *= base;
    }

    return result;
}
```

In the vast majority of cases, integer exponentiation will overflow the integral type. This is likely why such a function wasn't included in the std library in the first place.

Safer version that checks for overflow:
```cpp
#include <cassert>
#include <cstdint>
#include <limits>   // for std::numeric_limits

// safer but slower
// returns std::numeric_limits<std::int64_t>::max() if overflow occurs
constexpr std::int64_t powint_safe(std::int64_t base, int exp) {
    assert(exp >= 0 && "powint_safe: exp parameter has negative value");

    // handle 0 case
    if (base == 0) {
        return (exp == 0) ? 1 : 0;
    }

    std::int64_t result{ 1 };

    // to make range check easier, ensure base positive
    // flip result at end if needed
    bool negativeResult{ false };

    if (base < 0) {
        base = -base;
        negativeResult = (exp & 1);
    }

    while (exp > 0) {
        if (exp & 1) {
            // if exp is odd
            if (result > std::numeric_limits<std::int64_t>::max() / base) {
                std::cerr << "powint_safe(): result overflowed\n";
                return std::numeric_limits<std::int64_t>::max();
            }
            result *= base;
        }
        exp /= 2;

        // if we're done, return
        if (exp <= 0) {
            break;
        }

        // check if base will overflow when multiplied by base:
        if (base > std::numeric_limits<std::int64_t>::max() / base) {
            std::cerr << "powint_safe(): base overflowed\n";
            return std::numeric_limits<std::int64_t>::max();
        }

        base *= base;
    }

    if (negativeResult) {
        return -result;
    }

    return result;
}
```
