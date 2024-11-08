import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:mine_sweeper/presentation/controllers/game_controller.dart';
import '../../../../core/assets/app_image_assets.dart';
import '../../../../core/assets/app_svg_assets.dart';

class GameGrid extends StatelessWidget {
  const GameGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = GameController.to;

    return Expanded(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: controller.columnCount,
        ),
        itemCount: controller.rowCount * controller.columnCount,
        itemBuilder: (context, position) {
          final row = position ~/ controller.columnCount;
          final col = position % controller.columnCount;

          return InkWell(
            onTap: () => controller.handleTap(position),
            onLongPress: () => controller.toggleFlag(position),
            child: Obx(
              () => Container(
                color: Colors.grey,
                child: controller.revealedSquares[position]
                    ? _RevealedSquare(row: row, column: col)
                    : _HiddenSquare(position: position),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RevealedSquare extends StatelessWidget {
  final int row;
  final int column;
  const _RevealedSquare({
    required this.row,
    required this.column,
  });

  @override
  Widget build(BuildContext context) {
    final controller = GameController.to;

    return controller.board[row][column].hasBomb
        ? Image.asset(AppImageAssets.bomb)
        : _NumberTile(
            adjacentBombCount: controller.board[row][column].bombsAround,
          );
  }
}

class _NumberTile extends StatelessWidget {
  final int adjacentBombCount; // Number of adjacent bombs

  const _NumberTile({
    required this.adjacentBombCount,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _getImage(adjacentBombCount),
    );
  }

  // Helper function to determine the color based on bomb count
  String _getImage(int? count) {
    switch (count) {
      case 1:
        return AppImageAssets.one;
      case 2:
        return AppImageAssets.two;
      case 3:
        return AppImageAssets.three;
      case 4:
        return AppImageAssets.four;
      case 5:
        return AppImageAssets.five;
      case 6:
        return AppImageAssets.six;
      case 7:
        return AppImageAssets.seven;
      case 8:
        return AppImageAssets.eight;
      default:
        return AppImageAssets.none;
    }
  }
}


class _HiddenSquare extends StatelessWidget {
  final int position;
  const _HiddenSquare({
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final controller = GameController.to;

    return controller.flaggedSquares[position]
        ? Image.asset(AppImageAssets.flag)
        : SvgPicture.asset(AppSvgAssets.unselectedBox);
  }
}
