#include "add.h"
#include <iostream>

int readNumber() {
  std::cout << "Enter an integer: ";
  int x{};
  std::cin >> x;

  return x;
}

void writeNumber(int x, int y) {
  std::cout << "The sum of " << x << " and " << y << " is: " << add(x, y)
            << '\n';
}
