import 'package:blood_bridge/l10n/app_localizations.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/privacy_cubit/cubit/privacy_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/privacy_cubit/cubit/privacy_state.dart';
import 'package:blood_bridge/features/setting/presentation/views/widgets/setting_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/toggle_item.dart';

class PrivacySection extends StatelessWidget {
  const PrivacySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrivacyCubit, PrivacyState>(
      builder: (context, state) {
        return SettingsGroup(
          sectionTitle: 'Privacy',
          children: [
            ToggleItem(
              title: AppLocalizations.of(context)!.locationSharing,
              subtitle: 'For nearby matching',
              value: state.locationSharing,
              onChanged: (val) =>
                  context.read<PrivacyCubit>().toggleLocationSharing(val),
            ),
            ToggleItem(
              title: AppLocalizations.of(context)!.profileVisibility,
              subtitle: 'Show to other users',
              value: state.profileVisibility,
              onChanged: (val) =>
                  context.read<PrivacyCubit>().toggleProfileVisibility(val),
            ),
          ],
        );
      },
    );
  }
}
