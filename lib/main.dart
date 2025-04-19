import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:omborchi/config/router/app_routes.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:omborchi/core/modules/storage_module.dart';
import 'package:omborchi/core/theme/theme.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'core/database/app_storage.dart';
import 'feature/main/presentation/screen/select_theme/select_theme_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  await Hive.openBox(ExpenseFields.myBox);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await StorageModule.initBoxes();
  await AppStorage.init(); // AppStorage ni ishga tushiramiz

  await initDependencies();

  runApp(const CustomAppWidget());
}

class CustomAppWidget extends StatelessWidget {
  const CustomAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: ScreenUtilInit(
              useInheritedMediaQuery: false,
              designSize: MediaQuery.sizeOf(context),
              builder: (context, child) {
                return GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  initialRoute: RouteManager.splashScreen,
                  title: 'Omborchi',
                  themeMode: themeProvider.themeMode,
                  theme: AppTheme.theme,
                  darkTheme: AppTheme.darkTheme,
                  fallbackLocale: const Locale('en', 'EN'),
                  locale: Locale(
                    Provider.of<ThemeProvider>(context, listen: false)
                            .getString('lang') ??
                        "en",
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      child: child ?? Container(),
                    );
                  },
                  onGenerateRoute: (settings) =>
                      RouteManager.generateRoute(settings),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
