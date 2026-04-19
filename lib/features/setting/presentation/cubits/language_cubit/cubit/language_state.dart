import 'package:equatable/equatable.dart';

enum AppLanguage { english, arabic }

class LanguageState extends Equatable {
  final AppLanguage language;

  const LanguageState({this.language = AppLanguage.english});

  LanguageState copyWith({AppLanguage? language}) =>
      LanguageState(language: language ?? this.language);

  @override
  List<Object?> get props => [language];
}
