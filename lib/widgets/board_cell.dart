import 'package:flutter/material.dart';
import 'package:tic_tac_toe/components.dart';

class BoardCell extends StatelessWidget {
  const BoardCell({
    Key? key,
    required this.playerCell,
    required this.size,
    required this.onPressed,
  }) : super(key: key);

  final PlayerCell playerCell;
  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: onPressed,
        child: getImageWidget(),
      ),
    );
  }

  Widget getImageWidget() {
    switch (playerCell) {
      case PlayerCell.empty:
        return Container();

      case PlayerCell.playerX:
        return Image.asset("images/player-x.png");

      case PlayerCell.playerO:
        return Image.asset("images/player-o.png");
    }
  }
}
