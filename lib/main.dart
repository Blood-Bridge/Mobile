import 'dart:async';

import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/core/services/notification_service.dart';

import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/permissions/presntation/cubit/permissions_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/language_cubit/cubit/language_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/language_cubit/cubit/language_state.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/notifications_cubit/cubit/notifications_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/notifications_cubit/cubit/notifications_state.dart';

import 'package:blood_bridge/features/setting/presentation/views/setting_view.dart';
import 'package:blood_bridge/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await dotenv.load(fileName: "assets/env/.env");

  await Hive.openBox(HiveHelper.cachedLocationBox);
  await Hive.openBox(HiveHelper.onboardingBox);
  await Hive.openBox(HiveHelper.userBox);
  await Hive.openBox(HiveHelper.permissionsBox);
  await Hive.openBox('settings'); // ← box للـ notifications settings
  await Hive.openBox(HiveHelper.KEY_BOX_APP_LANGUAGE);

  await NotificationsService.init(); // ← init الإشعارات

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    print("🔥 Flutter Error: ${details.exception}");
  };

  runZonedGuarded(
    () {
      runApp(const MyApp());
    },
    (error, stack) {
      print("🔥 Uncaught Error: $error");
      print(stack);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(
          create: (context) => PermissionsCubit()..checkPermission(),
        ),
        BlocProvider(create: (context) => LanguageCubit()),
        // ← نمرر الـ box للـ Cubit عشان يقرأ ويحفظ منه
        BlocProvider(
          create: (context) => NotificationsCubit(Hive.box('settings')),
        ),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            locale: state.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: AppColors.bg,
              primaryColor: AppColors.primary,
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.border,
                elevation: 0,
              ),
            ),
            home: SettingView(),
          );
        },
      ),
    );
  }
}
