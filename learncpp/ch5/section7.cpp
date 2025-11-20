#include <iostream>
#include <string>

int main() {
  std::string name{};
  std::cout << "Enter your fulle name: ";
  std::getline(std::cin >> std::ws, name);

  int age{};
  std::cout << "Enter your age: ";
  std::cin >> age;

  std::cout << "Your age + length of name is: "
            << static_cast<int>(name.length()) + age << '\n';
  return 0;
}
