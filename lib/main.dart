import 'package:flutter/material.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:omborchi/feature/main/presentation/screen/main/main_screen.dart';

void main() async {
  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
   @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ValueNotifier(false),
      builder: (context, value, child) {
        return const GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Employee',
          themeMode: ThemeMode.light,
          // onGenerateRoute: (settings) => RouteManager.generateRoute(settings),
          home: MainScreen(),
        );
      },
    );
  }
}
