import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_sweeper/core/widgets/app_icon_button.dart';
import 'package:mine_sweeper/domain/enums/game_level.dart';
import 'package:mine_sweeper/presentation/pages/game_page/widgets/game_grid.dart';
import 'package:mine_sweeper/presentation/pages/game_page/widgets/header.dart';
import '../../controllers/game_controller.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GameController controller = Get.find<GameController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.level.levelName),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),

          /// Back button
          child: Obx(
            () => AppIconButton(
              onPressed: controller.onBackClicked,
              isEnabled: controller.isGameEnded(),
              icon: Icons.arrow_back_ios_new_outlined,
            ),
          ),
        ),

        actions: [

          /// Start new game button
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Obx(
              () => AppIconButton(
                onPressed: controller.resetGame,
                isEnabled: controller.isGameEnded(),
                icon: Icons.refresh,
              ),
            ),
          ),

        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// Timer, emoji, bomb count
                Header(),

                GameGrid(),
              ],
            ),

            /// Confetti Package
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: controller.confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 300,
                shouldLoop: false,
                colors: const [
                  Colors.red,
                  Colors.blue,
                  Colors.green,
                  Colors.orange,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
