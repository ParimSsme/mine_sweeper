import 'package:get/get.dart';
import 'package:mine_sweeper/presentation/bindings/game_binding.dart';
import 'package:mine_sweeper/presentation/pages/game_page/game_page.dart';
import 'package:mine_sweeper/presentation/pages/select_level_page.dart';
import '../../presentation/bindings/select_level_binding.dart';

class AppRoutes {
  static const String game = '/game';
  static const String selectLevel = '/select-level';

  static List<GetPage> routes = [
    GetPage(
      name: game,
      page: () => GamePage(),
      binding: GameBinding(),
    ),
    GetPage(
      name: selectLevel,
      page: () => const SelectLevelPage(),
      binding: SelectLevelBinding(),
    ),
  ];
}
