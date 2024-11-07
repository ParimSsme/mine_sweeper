import 'package:get/get.dart';
import '../controllers/game_controller.dart';
import '../../data/repositories/game_repository.dart';
import '../../domain/usecases/initialize_game.dart';

class GameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GameRepository());
    Get.lazyPut(() => InitializeGame(Get.find()));
    Get.lazyPut(() => GameController(initializeGame: Get.find()));
  }
}
