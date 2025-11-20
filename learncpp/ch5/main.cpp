/* Write a program that asks for the name and age of two people, then prints
 * which person is older
 *
 * Enter the name of person #1:
 * Enter the age of [person11]:
 * Enter the name of person #2:
 * Enter the age of [person2]:
 * person2 (age age2) is older than person1 (age age1)
 */

#include <iostream>
#include <string>
#include <string_view>

int main() {
  std::string person1{};
  std::cout << "Enter the name of person #1: ";
  std::getline(std::cin >> std::ws, person1);

  int age1{};
  std::cout << "Enter the age of " << person1 << ": ";
  std::cin >> age1;

  std::string person2{};
  std::cout << "Enter the name of person #2: ";
  std::getline(std::cin >> std::ws, person2);

  int age2{};
  std::cout << "Enter the age of " << person2 << ": ";
  std::cin >> age2;

  if (age1 > age2) {
    std::cout << person1 << " (age " << age1 << ") is older than " << person2
              << " (age " << age2 << ").\n";
  } else {
    std::cout << person2 << " (age " << age2 << ") is older than " << person1
              << " (age " << age1 << ").\n";
  }
  return 0;
}
