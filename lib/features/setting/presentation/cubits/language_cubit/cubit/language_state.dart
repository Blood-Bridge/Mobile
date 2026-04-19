import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum AppLanguage { english, arabic }

abstract class LanguageState {
  final Locale locale;
  const LanguageState(this.locale);
}

class SelectedLocale extends LanguageState {
  const SelectedLocale(Locale locale) : super(locale);
}
