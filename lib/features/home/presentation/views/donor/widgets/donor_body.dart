import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_button.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/widgets/requests_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DonorBody extends StatelessWidget {
  const DonorBody({super.key, required this.width, required this.height});
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
            Row(
              children: [
                Text('Nearby Requests', style: TextStyleHelper.h3(context)),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Map',
                    style: TextStyleHelper.small(
                      context,
                    ).copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) => RequestsContainer(
                height: height,
                width: width,
                isFirst: index == 0,
                address: 'a street in cairo',
                bloodType: 'O+',
                sitiuation: 'urgent',
                time: '4 hours',
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
