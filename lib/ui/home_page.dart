import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_sweeper/controller/game_controller.dart';
import 'package:mine_sweeper/ui/widgets/bomb_tile.dart';
import 'package:mine_sweeper/ui/widgets/number_tile.dart';

class HomePage extends GetView<GameController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // game stats and menu
          Container(
            height: 150,
            // color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // display number of bombs
                Column(
                  children: [
                    Text(controller.bombLocation.length.toString(),
                        style: TextStyle(fontSize: 40)),
                    Text('B O M B'),
                  ],
                ),

                // button to refresh the game
                GestureDetector(
                  onTap: controller.restartGame,
                  child: Card(
                    child: Icon(Icons.refresh, color: Colors.white, size: 40),
                    color: Colors.grey[700],
                  ),
                ),

                // display time taken
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('6', style: TextStyle(fontSize: 40)),
                    Text('T I M E'),
                  ],
                )
              ],
            ),
          ),

          // grid
          Expanded(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.numberOfSquares,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: controller.numberInEachRow),
              itemBuilder: (context, index) {
                if (controller.bombLocation.contains(index)) {
                  return Obx(
                    () => BombTile(
                      revealed: controller.bombsRevealed.value,
                      function: () {
                        // player tapped the bomb, so player loses
                        controller.playerLost();
                      },
                    ),
                  );
                } else {
                  return Obx(
                    () => NumberTile(
                      number: controller.squareStatus[index][0],
                      revealed: controller.squareStatus[index][1],
                      onPressed: () {
                        // reveal current box
                        controller.revealBoxNumbers(index);
                        controller.checkWinner();
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
