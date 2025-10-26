/* Question 2:
 * Ask the user to enter three values.
 * The program should then print these values.
 *
 * The program should match the following output
 * when run with input values 4, 5, 6
 *
 * > Enter three numbers: 4 5 6
 * > You entered 4, 5, and 6.
 */

#include <iostream>

int main() {
  int x{};
  int y{};
  int z{};

  std::cout << "Enter three numbers: ";
  std::cin >> x >> y >> z;

  std::cout << "You entered " << x << ", " << y << ", and " << z << ".\n";

  return 0;
}
