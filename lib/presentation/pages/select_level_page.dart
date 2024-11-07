import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_sweeper/core/routes/app_routes.dart';
import 'package:mine_sweeper/presentation/controllers/select_level_controller.dart';

import '../../core/services/game_service.dart';
import '../../domain/enums/game_level.dart';

class SelectLevelPage extends StatelessWidget {
  const SelectLevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GameService gameService = Get.find<GameService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Level',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: GameLevel.values.map((level) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Center(
                  child: Text(
                    level.toString().split('.').last.toUpperCase(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                onTap: () => SelectLevelController.to.selectLevel(level),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
