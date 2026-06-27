import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await dotenv.load(fileName: "assets/env/.env");

      await Hive.initFlutter();

      await Firebase.initializeApp();

      DioHelper.init();

      final position = await Geolocator.getCurrentPosition();

      await DioHelper.patchData(
        path: "Users/location",
        body: {"latitude": position.latitude, "longitude": position.longitude},
      );

      return true;
    } catch (e) {
      print("Background Task Error: $e");
      return false;
    }
  });
}
