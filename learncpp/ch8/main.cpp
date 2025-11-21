#include "Random.h"

#include <iostream>

namespace Constants {
constexpr int min{1};
constexpr int max{100};
constexpr int maxGuesses{10};
} // namespace Constants

int getGuess(int currentGuess) {
  int result{};
  std::cout << "Guess #" << currentGuess << ": ";
  std::cin >> result;

  return result;
}

bool evaluateGuess(int correct, int guess) {
  if (correct == guess) {
    std::cout << "Correct! You win!\n";
    return true;
  }

  if (correct < guess) {
    std::cout << "Your guess is too high.\n";
  } else {
    std::cout << "Your guess is too low.\n";
  }

  return false;
}

int main() {
  char keepPlaying{'y'};
  while (keepPlaying == 'y') {
    int currentGuess{1};
    std::cout << "Let's play a game. I'm thinking of a number between "
              << Constants::min << " and " << Constants::max << ". You have "
              << Constants::maxGuesses << " tries to guess what it is.\n";

    int correct{Random::get(Constants::min, Constants::max)};

    int guess{};
    while (currentGuess <= Constants::maxGuesses) {
      guess = getGuess(currentGuess++);
      if (evaluateGuess(correct, guess)) {
        break;
      }
    }

    std::cout << "Would you like to play again (y/n)? ";
    std::cin >> keepPlaying;
  }
  return 0;
}
