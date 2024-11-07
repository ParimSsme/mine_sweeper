import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_sweeper/core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/services/game_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  Get.lazyPut<GameService>(() => GameService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.selectLevel,
      defaultTransition: Transition.circularReveal,
      getPages: AppRoutes.routes,
    );
  }
}


