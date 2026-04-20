import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'language_state.dart';

// ✅ نستخدم Flutter بدل Platform
final Locale systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

class LanguageCubit extends Cubit<LanguageState> {
  static String? get cachedLanguage => HiveHelper.getLanguage();

  static Locale _locale = (cachedLanguage == null)
      ? (systemLocale.languageCode == 'ar'
            ? const Locale('ar')
            : const Locale('en'))
      : Locale(cachedLanguage!);

  static String? get currentLanguage => _locale.languageCode;

  LanguageCubit()
    : super(
        SelectedLocale(
          cachedLanguage == null ? _locale : Locale(cachedLanguage!),
        ),
      ) {
    if (cachedLanguage == null) {
      HiveHelper.setLanguage(_locale.languageCode);
    }
  }

  void toArabic() {
    Get.updateLocale(const Locale("ar"));
    HiveHelper.setLanguage('ar');
    emit(SelectedLocale(_locale = const Locale('ar')));
  }

  void toEnglish() {
    Get.updateLocale(const Locale("en"));
    HiveHelper.setLanguage('en');
    emit(SelectedLocale(_locale = const Locale('en')));
  }

  static bool get isArabic => currentLanguage == 'ar';
  static bool get isEnglish => currentLanguage == 'en';
}
