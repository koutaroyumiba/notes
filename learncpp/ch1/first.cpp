/* ask user for integer, tells them double the input
 * Enter an integer: 4
 * Double that number is: 8
 */

#include <iostream>

int main() {
  std::cout << "Enter an integer: ";
  int num{};
  std::cin >> num;

  std::cout << "Double that number is: " << num * 2 << '\n';
  std::cout << "Triple that number is: " << num * 3 << '\n';

  return 0;
}
