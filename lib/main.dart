import 'dart:io';

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
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';

import 'core/database/app_storage.dart';
import 'feature/main/presentation/screen/select_theme/select_theme_screen.dart';

const fetchTask = "fetch_questions_task";
const keepAliveTask = "keep_supabase_alive_task";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Initialize Supabase
      await Supabase.initialize(
        url: AppSecrets.supabaseUrl,
        anonKey: AppSecrets.supabaseAnonKey,
      );

      final supabase = Supabase.instance.client;

      if (task == fetchTask) {
        AppRes.logger.i("Bazani yangilash boshlandi");
        await supabase
            .from(ExpenseFields.rawMaterialTypeTable)
            .select('*')
            .limit(1);
        AppRes.logger.i("Bazani yangilash tugadi");
      }
      else if (task == keepAliveTask) {
        AppRes.logger.i("Keep-alive task boshlandi");

        // 1. Barcha eski ma'lumotlarni o'chirish
        await supabase
            .from('sleep_configure')
            .delete()
            .neq('id', 0); // Barcha yozuvlarni o'chirish

        AppRes.logger.i("Eski ma'lumotlar o'chirildi");

        // 2. Yangi ma'lumot qo'shish
        final currentTime = DateTime.now().toIso8601String();
        await supabase
            .from('sleep_configure')
            .insert({
          'last_update': currentTime,
        });

        AppRes.logger.i("Yangi ma'lumot qo'shildi: $currentTime");
      }

      return Future.value(true);
    } catch (err) {
      AppRes.logger.e("Task xatolik: $err");
      return Future.value(false);
    }
  });
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}



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

  // Initialize WorkManager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // Original task
  Workmanager().registerPeriodicTask(
    fetchTask,
    fetchTask,
    frequency: const Duration(days: 5),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  // // Keep-alive task - TEST UCHUN 15 MINUT
  // Workmanager().registerPeriodicTask(
  //   keepAliveTask,
  //   keepAliveTask,
  //   frequency: const Duration(minutes: 15), // Test uchun 15 minut
  //   constraints: Constraints(
  //     networkType: NetworkType.connected,
  //   ),
  //   existingWorkPolicy: ExistingWorkPolicy.replace,
  // );

  await StorageModule.initBoxes();
  await AppStorage.init();
  HttpOverrides.global = MyHttpOverrides();
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
                      child: SafeArea(child: child ?? Container()),
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