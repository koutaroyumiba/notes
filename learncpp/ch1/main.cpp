/* program that asks the user to enter a number and then enter a second number
 * should tell the user what the result of adding and subracting the two numbers
 * is
 */

#include <iostream>

int main() {
  int x{};
  int y{};
  std::cout << "Enter an integer: ";
  std::cin >> x;
  std::cout << "Enter another integer: ";
  std::cin >> y;

  std::cout << x << " + " << y << " is " << x + y << ".\n";
  std::cout << x << " - " << y << " is " << x - y << ".\n";
  return 0;
}
