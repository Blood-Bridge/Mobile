import 'package:blood_bridge/l10n/app_localizations.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/language_cubit/cubit/language_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/language_cubit/cubit/language_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final isEnglish = state.locale == const Locale('en');

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.language, color: AppColors.textMuted, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.language,
                    style: TextStyleHelper.h4(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _LangOption(
                    label: AppLocalizations.of(context)!.english,
                    isSelected: isEnglish,
                    onTap: () => context.read<LanguageCubit>().toEnglish(),
                  ),
                  const SizedBox(width: 10),
                  _LangOption(
                    label: AppLocalizations.of(context)!.text072,
                    isSelected: !isEnglish,
                    onTap: () => context.read<LanguageCubit>().toArabic(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LangOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LangOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 42,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.accent,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyleHelper.small(context).copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
