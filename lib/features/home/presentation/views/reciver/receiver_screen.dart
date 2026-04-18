import 'package:blood_bridge/features/home/presentation/views/reciver/widgets/receiver_appbar.dart';
import 'package:blood_bridge/features/home/presentation/views/reciver/widgets/receiver_body.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utiles/app_colors.dart';
import '../../../../../core/widgets/custom_button.dart';

// create login function with firebase auth

class ReceiverScreen extends StatelessWidget {
  const ReceiverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ReceiverAppBar(width: width, height: height),
            Expanded(
              child: ReceiverBody(width: width, height: height),
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: CustomButton(
                text: 'Profile',
                height: height * 0.06,
                width: width,
                backgroundColor: AppColors.popover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
