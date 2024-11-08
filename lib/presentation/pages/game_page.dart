import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mine_sweeper/core/assets/app_image_assets.dart';
import 'package:mine_sweeper/core/assets/app_svg_assets.dart';
import 'package:mine_sweeper/domain/enums/game_level.dart';
import 'package:mine_sweeper/presentation/widgets/number_tile.dart';
import '../../domain/enums/game_state.dart';
import '../controllers/game_controller.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GameController controller = Get.find<GameController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.level.levelName),
        centerTitle: true,
        leadingWidth: 70,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Obx(
              () => IconButton(
                onPressed: controller.isGameEnded()
                    ? () {
                        controller.resetGame();
                      }
                    : null,
                icon: Icon(
                  Icons.refresh,
                  size: 35.0,
                  color: controller.isGameEnded() ? Colors.white : Colors.white24,
                ),
              ),
            ),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Obx(
            () => IconButton(
              onPressed: controller.isGameEnded()
                  ? () {
                controller.onBackClicked();
              }
                  : null,
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 30.0,
                color: controller.isGameEnded() ? Colors.white : Colors.white24,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Obx(
                          () => Text(
                            controller.bombCount.value
                                .toString()
                                .padLeft(3, '0'),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Obx(() {
                        switch (controller.gameState.value) {
                          case GameState.won:
                            return SvgPicture.asset(
                              AppSvgAssets.happyEmoji,
                              height: 50,
                              width: 60,
                            );
                          case GameState.lost:
                            return SvgPicture.asset(
                              AppSvgAssets.angryEmoji,
                              height: 50,
                              width: 60,
                            );
                          default:
                            return SvgPicture.asset(
                              AppSvgAssets.noFeelingEmoji,
                              height: 50,
                              width: 60,
                            );
                        }
                      }),
                      Container(
                        color: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Obx(
                          () => Text(
                            controller.elapsedTime.value
                                .toString()
                                .padLeft(3, '0'),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                                  : NumberTile(
                                      adjacentBombCount: controller
                                          .board[row][col].bombsAround)
                              : controller.flaggedSquares[position]
                                  ? Image.asset(AppImageAssets.flag)
                                  : SvgPicture.asset(
                                      AppSvgAssets.unselectedBox),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            // Confetti effect
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: controller.confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 300,
                shouldLoop: false, // Only play once when triggered
                colors: const [
                  Colors.red,
                  Colors.blue,
                  Colors.green,
                  Colors.orange,
                ], // Customize colors
              ),
            ),
          ],
        ),
      ),
    );
  }
}
