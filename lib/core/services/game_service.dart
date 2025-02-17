import 'package:get/get.dart';
import '../../domain/enums/game_level.dart';

class GameService extends GetxService {
  static GameService get to => Get.find();

  var selectedLevel = GameLevel.easy.obs;

  void setGameLevel(GameLevel level) {
    selectedLevel.value = level;
  }

  GameLevel get getGameLevel => selectedLevel.value;
}