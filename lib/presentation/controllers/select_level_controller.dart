import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/game_service.dart';
import '../../domain/enums/game_level.dart';

class SelectLevelController extends GetxController {
  static SelectLevelController get to => Get.find();

  final GameService _gameService = Get.find<GameService>();

  void selectLevel(GameLevel level) {
    _gameService.setGameLevel(level);
    Get.offNamed(AppRoutes.game);
  }
}
