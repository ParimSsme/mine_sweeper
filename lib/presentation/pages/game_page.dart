import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mine_sweeper/core/assets/app_image_assets.dart';
import 'package:mine_sweeper/core/assets/app_svg_assets.dart';
import 'package:mine_sweeper/presentation/widgets/number_tile.dart';
import '../controllers/game_controller.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GameController controller = Get.find<GameController>();

    return Scaffold(
      body: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: controller.columnCount,
            ),
            itemCount: controller.rowCount * controller.columnCount,
            itemBuilder: (context, position) {
              // Obtain row and column numbers
              int row = position ~/ controller.columnCount;
              int col = position % controller.columnCount;

              return InkWell(
                onTap: () => controller.handleTap(position),
                child: Container(
                  color: Colors.grey,
                  child: Obx(
                    () => controller.revealedSquares[position]
                        ? controller.board[row][col].hasBomb
                            ? Image.asset(AppImageAssets.bomb)
                            : NumberTile(adjacentBombCount: controller.board[row][col].bombsAround)
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
