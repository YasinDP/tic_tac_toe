import 'package:flutter/material.dart';
import 'package:tic_tac_toe/AI/ai.dart';
import 'package:tic_tac_toe/components.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/widgets/board_cell.dart';

class SinglePlayerGameScreen extends StatefulWidget {
  static String routeName = "/single-player";
  const SinglePlayerGameScreen({Key? key}) : super(key: key);

  @override
  State<SinglePlayerGameScreen> createState() => _SinglePlayerGameScreenState();
}

class _SinglePlayerGameScreenState extends State<SinglePlayerGameScreen> {
  int rowCount = 3;
  late List<List<PlayerCell>> matrix;
  CurrentPlayerSP _currentPlayer = CurrentPlayerSP.player;
  bool aiIsPlaying = false;

  @override
  void initState() {
    matrix = List.generate(
      rowCount,
      (_) => List.generate(rowCount, (_) => PlayerCell.empty),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _getBackgroundColor(),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "SINGLE PLAYER",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: kPrimaryColor, shape: BoxShape.circle),
              child: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            )),
      ),
      backgroundColor: _getBackgroundColor(),
      body: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: matrix.asMap().entries.map((items) {
              int columnIndex = items.key;
              return buildRow(items.value, columnIndex);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    return _currentPlayer == CurrentPlayerSP.player
        ? kPlayerXColor
        : kPlayerOColor;
  }

  Widget buildRow(List<PlayerCell> items, int columnIndex) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items.asMap().entries.map((item) {
        int rowIndex = item.key;
        // int cellIndex = (columnIndex * rowCount) + rowIndex; //get cell index
        return BoardCell(
          playerCell: item.value,
          size: width * 0.3,
          onPressed: () {
            if (!aiIsPlaying && _currentPlayer == CurrentPlayerSP.player) {
              _markCell(columnIndex, rowIndex);
            }
          },
        );
      }).toList(),
    );
  }

  void _markCell(int columnIndex, int rowIndex) async {
    if (matrix[columnIndex][rowIndex] == PlayerCell.empty) {
      setState(() {
        matrix[columnIndex][rowIndex] = _currentPlayer == CurrentPlayerSP.player
            ? PlayerCell.playerX
            : PlayerCell.playerO;
      });
    }

    if (_isWinner()) {
      _winnerDialog();
      return;
    }

    if (_cellsFilled()) {
      _endDialog();
      return;
    }

    setState(() {
      _currentPlayer = _currentPlayer == CurrentPlayerSP.player
          ? CurrentPlayerSP.ai
          : CurrentPlayerSP.player;
    });
    if (_currentPlayer == CurrentPlayerSP.ai) {
      setState(() {
        aiIsPlaying = true;
      });
      await Future.delayed(const Duration(seconds: 1), () {
        _markCellByAI();
      });
    }
  }

  void _markCellByAI() {
    if (AI().isCenterEmpty(matrix)) {
      setState(() {
        matrix[1][1] = PlayerCell.playerO;
      });
    } else {
      List<int> indexes = AI().chooseRandom(matrix);
      setState(() {
        matrix[indexes[0]][indexes[1]] = PlayerCell.playerO;
      });
    }

    if (_isWinner()) {
      _winnerDialog();
      return;
    }

    if (_cellsFilled()) {
      _endDialog();
      return;
    }

    setState(() {
      aiIsPlaying = false;
      _currentPlayer = CurrentPlayerSP.player;
    });
  }

  bool _isWinner() {
    List<bool> winningMatches = [
      _isMatch([0, 0], [1, 0], [2, 0]),
      _isMatch([0, 1], [1, 1], [2, 1]),
      _isMatch([0, 2], [1, 2], [2, 2]),
      _isMatch([0, 0], [0, 1], [0, 1]),
      _isMatch([1, 0], [1, 1], [1, 2]),
      _isMatch([2, 0], [2, 1], [2, 2]),
      _isMatch([2, 0], [1, 1], [0, 2]),
      _isMatch([0, 0], [1, 1], [2, 2]),
    ];
    return winningMatches.contains(true);
  }

  bool _isMatch(List<int> cellA, List<int> cellB, List<int> cellC) {
    PlayerCell a = matrix[cellA[0]][cellA[1]];
    PlayerCell b = matrix[cellB[0]][cellB[1]];
    PlayerCell c = matrix[cellC[0]][cellC[1]];

    if (a != PlayerCell.empty) {
      if (a == b && b == c) {
        return true;
      }
    }
    return false;
  }

  _winnerDialog() {
    double width = MediaQuery.of(context).size.width;
    String winnerText = _currentPlayer == CurrentPlayerSP.player
        ? "Congrats You Won!"
        : "Computer Won! Try Again";
    String winnerImageUrl = _currentPlayer == CurrentPlayerSP.player
        ? "images/player-x.png"
        : "images/player-o.png";
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              winnerText,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: kPrimaryColor,
              ),
            ),
            content: Image.asset(
              winnerImageUrl,
              fit: BoxFit.contain,
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              InkWell(
                onTap: _restartGame,
                child: Container(
                  width: width * 0.2,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: kPrimaryColor,
                  ),
                  child: const Text(
                    "Restart",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).popUntil(ModalRoute.withName("/"));
                },
                child: Container(
                  width: width * 0.2,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: kPrimaryColor,
                  ),
                  child: const Text(
                    "Quit",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  bool _cellsFilled() {
    return matrix
        .every((items) => items.every((item) => item != PlayerCell.empty));
  }

  _endDialog() {
    double width = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Its a Tie game",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: kPrimaryColor,
              ),
            ),
            content: Image.asset(
              "images/warning-icon.png",
              fit: BoxFit.contain,
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              InkWell(
                onTap: _restartGame,
                child: Container(
                  width: width * 0.2,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: kPrimaryColor,
                  ),
                  child: const Text(
                    "Restart",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).popUntil(ModalRoute.withName("/"));
                },
                child: Container(
                  width: width * 0.2,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: kPrimaryColor,
                  ),
                  child: const Text(
                    "Quit",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _restartGame() {
    Navigator.of(context).pop();
    setState(() {
      matrix = List.generate(
        rowCount,
        (_) => List.generate(rowCount, (_) => PlayerCell.empty),
      );
      _currentPlayer = CurrentPlayerSP.player;
    });
  }
}
