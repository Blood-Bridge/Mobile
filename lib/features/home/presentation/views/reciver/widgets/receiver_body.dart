import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_button.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/widgets/requests_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'active_requests_container.dart';

class ReceiverBody extends StatelessWidget {
  const ReceiverBody({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Active Requests', style: TextStyleHelper.h3(context)),
            SizedBox(height: height * 0.02),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) => ActiveRequestsContainer(
                height: height,
                width: width,
                isConfirmed: index == 0,
                donorsNumber: 5,
                bloodType: 'O+',
                situation: 'urgent',
                time: '4 h',
                distance: '5 KM',
              ),
              separatorBuilder: (context, index) =>
                  SizedBox(height: height * 0.03),
            ),
          ],
        ),
      ),
    );
  }
}
