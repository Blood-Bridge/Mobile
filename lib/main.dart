import 'dart:async';

import 'package:blood_bridge/app_initializer.dart';
import 'package:blood_bridge/core/services/callback_dispatcher.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/core/services/notification_service.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/admin_dashboard/presentation/views/admin_dashboard_screen.dart';
import 'package:blood_bridge/features/admin_dashboard/presentation/views/backup_screen.dart';
import 'package:blood_bridge/features/admin_dashboard/presentation/views/language_settings_screen.dart';
import 'package:blood_bridge/features/admin_dashboard/presentation/views/system_logs_screen.dart';
import 'package:blood_bridge/features/admin_dashboard/presentation/views/admin_donors_screen.dart';
import 'package:blood_bridge/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/cubit/cubit/donor_cubit.dart';
import 'package:blood_bridge/features/hospital_profile/presentation/cubit/hospital_profile_cubit.dart';
import 'package:blood_bridge/features/permissions/presntation/cubit/permissions_cubit.dart';
import 'package:blood_bridge/features/splash/presentaion/views/splash_screen.dart';
import 'package:blood_bridge/features/hospital_dashboard/presentation/views/hospital_dashboard_screen.dart';
import 'package:blood_bridge/features/home/presentation/views/reciver/cubit/receiver_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/views/setting_view.dart';
import 'package:blood_bridge/features/user_information/presentation/cubit/info_cubit.dart';
import 'package:blood_bridge/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:blood_bridge/features/notifications/presentation/cubit/app_notifications_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/language_cubit/cubit/language_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/language_cubit/cubit/language_state.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/notifications_cubit/cubit/notifications_cubit.dart';
import 'package:blood_bridge/features/donations/presentation/cubit/donations_cubit.dart';
import 'package:blood_bridge/features/donations/presentation/views/donations_list_screen.dart';
import 'package:blood_bridge/features/request_status/presentation/cubit/request_status_cubit.dart';
import 'package:blood_bridge/features/matching/presentation/cubit/match_cubit.dart';
import 'package:blood_bridge/features/admin_dashboard/presentation/cubit/admin_requests_cubit.dart';
import 'package:blood_bridge/features/admin_dashboard/presentation/views/admin_requests_screen.dart';
import 'package:blood_bridge/features/admin_dashboard/presentation/cubit/admin_donations_cubit.dart';
import 'package:blood_bridge/features/admin_dashboard/presentation/views/admin_donations_screen.dart';
import 'package:blood_bridge/features/recommendations/presentation/cubit/recommendation_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/switch_role_cubit/switch_role_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/delete_account_cubit/delete_account_cubit.dart';
import 'package:blood_bridge/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Firebase.initializeApp();
  await dotenv.load(fileName: "assets/env/.env");
  DioHelper.init();
  await Hive.openBox(HiveHelper.cachedLocationBox);
  await Hive.openBox(HiveHelper.onboardingBox);
  await Hive.openBox(HiveHelper.userBox);
  await Hive.openBox(HiveHelper.permissionsBox);
  await Hive.openBox(HiveHelper.avilablityBox);
  await Hive.openBox('settings');
  await Hive.openBox(HiveHelper.KEY_BOX_APP_LANGUAGE);
  await AppInitializer();
  await NotificationsService.init();
  Workmanager().initialize(callbackDispatcher);

  Workmanager().registerPeriodicTask(
    "locationTask",
    "updateLocation",
    frequency: const Duration(minutes: 15),
  );

  FlutterError.onError = (details) {
    FlutterError.dumpErrorToConsole(details);
    print("🔥 Flutter Error: ${details.exception}");
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => PermissionsCubit()..checkPermission()),
        BlocProvider(create: (_) => InfoCubit()),
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(create: (_) => NotificationsCubit(Hive.box('settings'))),
        BlocProvider(create: (_) => DonorCubit()),
        BlocProvider(create: (_) => ReceiverCubit()),
        BlocProvider(create: (_) => ProfileCubit()..fetchProfile()),
        BlocProvider(
          create: (_) => AppNotificationsCubit()..fetchNotifications(),
        ),
        BlocProvider(create: (_) => DonationsCubit()),
        BlocProvider(create: (_) => RequestStatusCubit()),
        BlocProvider(create: (_) => MatchCubit()),
        BlocProvider(create: (_) => AdminRequestsCubit()),
        BlocProvider(create: (_) => AdminDonationsCubit()),
        BlocProvider(create: (_) => RecommendationCubit()),
        BlocProvider(create: (_) => SwitchRoleCubit()),
        BlocProvider(create: (_) => DeleteAccountCubit()),
        BlocProvider(create: (_) => HospitalProfileCubit()),
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
            home: const SplashScreen(),

            getPages: [
              GetPage(name: '/admin', page: () => AdminDashboardScreen()),
              GetPage(name: '/admin/logs', page: () => SystemLogsScreen()),
              GetPage(name: '/admin/donors', page: () => AdminDonorsScreen()),
              GetPage(
                name: '/admin/requests',
                page: () => AdminRequestsScreen(),
              ),
              GetPage(
                name: '/admin/donations',
                page: () => AdminDonationsScreen(),
              ),
              GetPage(name: '/admin/backup', page: () => BackupScreen()),
              GetPage(
                name: '/admin/language',
                page: () => LanguageSettingsScreen(),
              ),
              GetPage(
                name: '/hospital',
                page: () => const HospitalDashboardScreen(),
              ),
              GetPage(name: '/settings', page: () => const SettingView()),
              GetPage(
                name: '/donations',
                page: () => const DonationsListScreen(),
              ),
            ],
          );
        },
      ),
    );
  }
}
