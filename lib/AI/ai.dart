import 'dart:math';

import 'package:tic_tac_toe/components.dart';

class AI {
  bool isCenterEmpty(List<List<PlayerCell>> matrix) {
    if (matrix[1][1] == PlayerCell.empty) {
      return true;
    } else {
      return false;
    }
  }

  List<int> chooseRandom(List<List<PlayerCell>> matrix) {
    var random = Random();
    while (true) {
      var _row = random.nextInt(3);
      var _column = random.nextInt(3);

      if (matrix[_column][_row] == PlayerCell.empty) {
        return [_column, _row];
      }
    }
  }
}
