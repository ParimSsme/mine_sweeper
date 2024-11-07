import 'package:get/get.dart';
import 'package:mine_sweeper/presentation/controllers/select_level_controller.dart';

class SelectLevelBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => SelectLevelController());
  }
}