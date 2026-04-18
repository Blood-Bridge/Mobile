import 'package:blood_bridge/core/utiles/extentions.dart';
import 'package:blood_bridge/features/user_information/presentation/views/widgets/info_body.dart';
import 'package:blood_bridge/features/user_information/presentation/views/widgets/user_info_appbar.dart';
import 'package:flutter/material.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final height = context.height;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            UserInfoAppBar(width: width, height: height, i: 2),
            Expanded(
              child: InfoBody(width: width, height: height),
            ),
          ],
        ),
      ),
    );
  }
}
