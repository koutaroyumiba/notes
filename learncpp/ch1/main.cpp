#include <iostream>

int main() {
  std::cout << "Enter a number: "; // ask user for a number

  int x{};       // define x to hold user input
  std::cin >> x; // get number from user

  std::cout << "You entered " << x << '\n';
  return 0;
}
