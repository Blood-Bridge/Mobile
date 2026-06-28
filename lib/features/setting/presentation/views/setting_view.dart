import 'package:blood_bridge/features/setting/presentation/views/widgets/setting_view_body.dart';
import 'package:flutter/cupertino.dart';

class SettingView extends StatelessWidget {
  final bool isHospital;
  const SettingView({super.key, this.isHospital = false});

  @override
  Widget build(BuildContext context) {
    return SettingViewBody(isHospital: isHospital);
  }
}
