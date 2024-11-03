import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mine_sweeper/core/assets/app_image_assets.dart';
import 'package:mine_sweeper/core/assets/app_svg_assets.dart';
import 'package:mine_sweeper/presentation/widgets/number_tile.dart';
import '../../domain/enums/game_state.dart';
import '../controllers/game_controller.dart';

class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GameController controller = Get.find<GameController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          switch (controller.gameState.value) {
            case GameState.won:
              return Text("You Win!");
            case GameState.lost:
              return Text("Game Over");
            default:
              return Text("Minesweeper");
          }
        }),
      ),
      body: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: controller.columnCount,
            ),
            itemCount: controller.rowCount * controller.columnCount,
            itemBuilder: (context, position) {
              int row = position ~/ controller.columnCount;
              int col = position % controller.columnCount;

              return InkWell(
                onTap: () => controller.handleTap(position),
                onLongPress: () => controller.toggleFlag(position),
                child: Container(
                  color: Colors.grey,
                  child: Obx(
                    () => controller.revealedSquares[position]
                        ? controller.board[row][col].hasBomb
                            ? Image.asset(AppImageAssets.bomb)
                            : NumberTile(adjacentBombCount: controller.board[row][col].bombsAround)
                        :  controller.flaggedSquares[position]
                        ? Image.asset(AppImageAssets.flag)
                        : SvgPicture.asset(AppSvgAssets.unselectedBox),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
