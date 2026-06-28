import 'package:blood_bridge/core/l10n_ext.dart';
import 'package:blood_bridge/core/models/snackbar_type.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_snackbar.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/switch_role_cubit/switch_role_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/switch_role_cubit/switch_role_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserTypeSelector extends StatelessWidget {
  const UserTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SwitchRoleCubit, SwitchRoleState>(
      listener: (context, state) {
        if (state is SwitchRoleSuccess) {
          showSnackBar("Success", state.message, SnackbarType.success);
        } else if (state is SwitchRoleError) {
          showSnackBar("Error", state.message, SnackbarType.error);
        }
      },
      builder: (context, state) {
        final isLoading = state is SwitchRoleLoading;
        final isDonor = state is SwitchRoleSuccess
            ? state.message.toLowerCase().contains('donor')
            : false;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.swap_horiz, color: AppColors.textMuted, size: 22),
                  const SizedBox(width: 10),
                  Text(context.l10n.userType, style: TextStyleHelper.h4(context)),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  _TypeOption(
                    label: context.l10n.donor,
                    isSelected: isDonor,
                    isLoading: isLoading,
                    onTap: () {
                      // هنا تحتاج تفتح BottomSheet أو Dialog لإدخال البيانات
                      _showSwitchToDonorDialog(context);
                    },
                  ),
                  const SizedBox(width: 12),
                  _TypeOption(
                    label: context.l10n.recipient,
                    isSelected: !isDonor,
                    isLoading: isLoading,
                    onTap: () =>
                        context.read<SwitchRoleCubit>().switchToRecipient(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSwitchToDonorDialog(BuildContext context) {
    // TODO: Implement form for weight, dob, medical history, nationalId, location
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.switchToDonor),
        content: Text(context.l10n.weightDobEtc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.text100),
          ),
          ElevatedButton(
            onPressed: () {
              // Example call
              context.read<SwitchRoleCubit>().switchToDonor(
                weight: 70,
                dateOfBirth: '1995-01-01',
                medicalHistory: '',
                nationalId: '12345678901234',
                latitude: 30.0444,
                longitude: 31.2357,
              );
              Navigator.pop(context);
            },
            child: Text(context.l10n.text101),
          ),
        ],
      ),
    );
  }
}

class _TypeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const _TypeOption({
    required this.label,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 52,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.body(context).copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
        ),
      ),
    );
  }
}
