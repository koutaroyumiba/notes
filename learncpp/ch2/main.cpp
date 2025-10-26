/* read two separate integers from the user,
 * add them together,
 * then output the answer
 */

#include "io.h"

int main() {
  int x{readNumber()};
  int y{readNumber()};
  writeNumber(x, y);
  return 0;
}
