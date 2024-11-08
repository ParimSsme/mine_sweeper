import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:mine_sweeper/presentation/controllers/game_controller.dart';
import '../../../../core/assets/app_svg_assets.dart';
import '../../../../domain/enums/game_state.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = GameController.to;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          /// Bomb count
          _Counter(
            count: controller.bombCount,
            color: Colors.red,
          ),

          const _EmojiIcon(),

          /// Timer
          _Counter(
            count: controller.elapsedTime,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  final RxInt count;
  final Color color;
  const _Counter({
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Obx(
        () => Text(
          count.value.toString().padLeft(3, '0'),
          style: TextStyle(
            fontSize: 24,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


class _EmojiIcon extends StatelessWidget {
  const _EmojiIcon();

  @override
  Widget build(BuildContext context) {

    final controller = GameController.to;

    return Obx(() {
      final emojiAsset = controller.gameState.value == GameState.won
          ? AppSvgAssets.happyEmoji
          : (controller.gameState.value == GameState.lost
          ? AppSvgAssets.angryEmoji
          : AppSvgAssets.noFeelingEmoji);
      return SvgPicture.asset(emojiAsset, height: 50, width: 60);
    });
  }
}
