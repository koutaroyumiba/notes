/* user is asked to enter 2 floating numbers (use doubles)
 * user is asked to enter one of the following symbols: + - * /
 * compute the answer on the two numbers and print the result
 * user enters an invalid symbol -> print nothing
 *
 * enter a double value: x
 * enter a double value: y
 * enter +, -, *, or /: z
 * x z y is result
 */

#include <iostream>

double getDoubleValue() {
  double x{};
  std::cout << "Enter a double value: ";
  std::cin >> x;
  return x;
}

char getOperator() {
  char op{};
  std::cout << "Enter +, -, *, or /: ";
  std::cin >> op;
  return op;
}

int main() {
  double x{getDoubleValue()};
  double y{getDoubleValue()};
  char op{getOperator()};
  double result{};

  if (op == '+') {
    result = x + y;
  } else if (op == '-') {
    result = x - y;
  } else if (op == '*') {
    result = x * y;
  } else if (op == '/') {
    result = x / y;
  } else {
    result = -1;
  }

  std::cout << x << " " << op << " " << y << " is " << result << '\n';
}
