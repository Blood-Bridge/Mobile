import 'dart:async';

import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/core/services/notification_service.dart';

import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/connectivity_status/data/repositories/connectivity_status_repository_impl.dart';
import 'package:blood_bridge/features/connectivity_status/presentation/cubit/connectivity_status_cubit.dart';
import 'package:blood_bridge/features/connectivity_status/presentation/widgets/connectivity_status_overlay.dart';
import 'package:blood_bridge/features/hospital_inventory/presentation/views/hospital_inventory_view.dart';
import 'package:blood_bridge/features/permissions/presntation/cubit/permissions_cubit.dart';
import 'package:blood_bridge/features/profile/presentation/views/profile_view.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/Preferences_cubit/cubit/preferences_state.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/language_cubit/cubit/language_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/language_cubit/cubit/language_state.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/notifications_cubit/cubit/notifications_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/preferences_cubit/cubit/preferences_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/privacy_cubit/cubit/privacy_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/views/setting_view.dart';
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
  await Hive.openBox(HiveHelper.KEY_BOX_APP_LANGUAGE);
  await Hive.openBox(HiveHelper.cachedLocationBox);
  await Hive.openBox(HiveHelper.onboardingBox);
  await Hive.openBox(HiveHelper.userBox);
  await Hive.openBox(HiveHelper.permissionsBox);
  await Hive.openBox('settings');
  await Hive.openBox(HiveHelper.KEY_BOX_APP_LANGUAGE);
  await NotificationsService.init();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    print("🔥 Flutter Error: ${details.exception}");
  };

  runZonedGuarded(() => runApp(const MyApp()), (error, stack) {
    print("🔥 Uncaught Error: $error");
    print(stack);
  });
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
        BlocProvider(
          create: (context) => NotificationsCubit(Hive.box('settings')),
        ),
        BlocProvider(create: (context) => PrivacyCubit(Hive.box('settings'))),
        BlocProvider(
          create: (context) => PreferencesCubit(Hive.box('settings')),
        ),
        // App-wide connectivity / location-service watcher.
        // Swap ConnectivityStatusRepositoryImpl() for
        // ConnectivityStatusRepositoryMock() during UI development.
        BlocProvider(
          create: (context) =>
              ConnectivityStatusCubit(ConnectivityStatusRepositoryImpl())
                ..start(),
        ),
      ],
      // استمع للغة والـ dark mode مع بعض
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, langState) {
          return BlocBuilder<PreferencesCubit, PreferencesState>(
            builder: (context, prefsState) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                locale: langState.locale == AppLanguage.arabic
                    ? const Locale('ar')
                    : const Locale('en'),
                supportedLocales: const [Locale('en'), Locale('ar')],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                // ← Dark Mode يغير الـ theme بتاع التطبيق كله
                theme: prefsState.darkMode
                    ? ThemeData.dark().copyWith(
                        scaffoldBackgroundColor: AppColors.bg,
                        primaryColor: AppColors.primary,
                        appBarTheme: const AppBarTheme(
                          backgroundColor: AppColors.border,
                          elevation: 0,
                        ),
                      )
                    : ThemeData.light().copyWith(
                        primaryColor: AppColors.primary,
                        appBarTheme: const AppBarTheme(elevation: 0),
                      ),
                // الـ Overlay هيلف أي شاشة ويظهر "No Connection" أو
                // "Location Disabled" تلقائي لو حصلت مشكلة.
                builder: (context, child) =>
                    ConnectivityStatusOverlay(child: child!),
                home: HospitalInventoryView(hospitalId: ''),
              );
            },
          );
        },
      ),
    );
  }
}
