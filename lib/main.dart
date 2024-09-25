
import 'package:flutter/material.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/presentation/screen/raw_material/raw_material_screen.dart';
import 'package:omborchi/feature/main/presentation/screen/raw_material_type/raw_material_type_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get the directory for storing Hive data
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // Open the hive box
  await Hive.openBox(ExpenseFields.myBox);

  
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
          title: 'Omborchi',
          themeMode: ThemeMode.light,
          // onGenerateRoute: (settings) => RouteManager.generateRoute(settings),
          home: RawMaterialScreen(),
        );
      },
    );
  }
}
