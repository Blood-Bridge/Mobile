import 'dart:async';

import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/donor_screen.dart';
import 'package:blood_bridge/features/map/presentation/view/map_screen.dart';
import 'package:blood_bridge/features/permissions/presntation/cubit/permissions_cubit.dart';
import 'package:blood_bridge/features/permissions/presntation/views/permissions_screen.dart';
import 'package:blood_bridge/features/setting/presentation/views/setting_view.dart';
import 'package:blood_bridge/features/user_information/presentation/views/user_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/home/presentation/views/reciver/receiver_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await dotenv.load(fileName: "assets/env/.env");

  // await Firebase.initializeApp();
  await Hive.openBox(HiveHelper.cachedLocationBox);
  await Hive.openBox(HiveHelper.onboardingBox);
  await Hive.openBox(HiveHelper.userBox);
  await Hive.openBox(HiveHelper.permissionsBox);

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(
          create: (context) => PermissionsCubit()..checkPermission(),
        ),
      ],
      child: GetMaterialApp(
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.bg,
          primaryColor: AppColors.primary,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.border,
            elevation: 0,
          ),
        ),

        debugShowCheckedModeBanner: false,
        home: SettingView(),
      ),
    );
  }
}
