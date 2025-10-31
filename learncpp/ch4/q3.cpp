/* simulate a ball being dropped off of a tower
 * ask user for the height of the tower (m)
 * assume normal gravity (9.8) and no initial velocity
 * output the height of the ball above the ground after 0, 1, 2, 3, 4, and 5s
 * the ball should not go underneath the ground
 *
 * d = g * (seconds)^2  / 2
 */
#include <iostream>

double getTowerHeight() {
  std::cout << "Enter the height of the tower in meters: ";
  double x{};
  std::cin >> x;
  return x;
}

double calculateCurrentDistance(double startingDistance, int seconds) {
  double gravityConstant{9.8};

  double distanceFallen = gravityConstant * seconds * seconds / 2;
  if (startingDistance - distanceFallen < 0) {
    return 0;
  }
  return startingDistance - distanceFallen;
}

void printDistance(int second, double distance) {
  if (distance == 0) {
    std::cout << "At " << second << " seconds, the ball is on the ground.\n";
  } else {
    std::cout << "At " << second
              << " seconds, the ball is at height: " << distance << " meters\n";
  }
}

int main() {
  double start{getTowerHeight()};
  for (int i = 0; i < 6; i++) {
    double dist = calculateCurrentDistance(start, i);
    printDistance(i, dist);
  }
}
