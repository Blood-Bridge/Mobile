import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  static String? get cachedLanguage => HiveHelper.getLanguage();

  static Locale _locale = const Locale('en');

  static String? get currentLanguage => _locale.languageCode;

  LanguageCubit() : super(SelectedLocale(_getInitialLocale()));

  static Locale _getInitialLocale() {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

    if (cachedLanguage == null) {
      return systemLocale.languageCode == 'ar'
          ? const Locale('ar')
          : const Locale('en');
    } else {
      return Locale(cachedLanguage!);
    }
  }

  void toArabic() {
    _locale = const Locale('ar');
    Get.updateLocale(_locale);
    HiveHelper.setLanguage('ar');
    emit(SelectedLocale(_locale));
  }

  void toEnglish() {
    _locale = const Locale('en');
    Get.updateLocale(_locale);
    HiveHelper.setLanguage('en');
    emit(SelectedLocale(_locale));
  }

  static bool get isArabic => currentLanguage == 'ar';
  static bool get isEnglish => currentLanguage == 'en';
}
