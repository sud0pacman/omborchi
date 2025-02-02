import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:omborchi/config/router/app_routes.dart';
import 'package:omborchi/core/custom/extensions/my_extensions.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:omborchi/core/modules/hive_db_helper.dart';
import 'package:omborchi/core/modules/storage_module.dart';
import 'package:omborchi/core/theme/theme.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/presentation/screen/splash/splash_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  await Hive.openBox(ExpenseFields.myBox);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await StorageModule.initBoxes();

  await initDependencies();

  runApp(CustomAppWidget());
}

class CustomAppWidget extends StatelessWidget {
  final preferences = inject<AppPreferences>();

  CustomAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: preferences.themeListenable(),
      builder: (context, value, child) {
        return ScreenUtilInit(
          useInheritedMediaQuery: false,
          designSize: MediaQuery.sizeOf(context),
          builder: (context, child) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Edu Track',
              // themeMode: preferences.theme,
              themeMode: ThemeMode.system,
              theme: AppTheme.theme,
              darkTheme: AppTheme.darkTheme,
              fallbackLocale: const Locale('en', 'EN'),
              locale: Locale(preferences.lang ?? "en"),
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
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}
