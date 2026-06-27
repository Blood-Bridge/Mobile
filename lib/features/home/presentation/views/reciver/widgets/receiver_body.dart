import 'package:blood_bridge/core/models/snackbar_type.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_button.dart';
import 'package:blood_bridge/core/widgets/custom_snackbar.dart';
import 'package:blood_bridge/features/home/presentation/views/reciver/cubit/receiver_cubit.dart';
import 'package:blood_bridge/features/home/presentation/views/reciver/widgets/active_requests_container.dart';
import 'package:blood_bridge/features/matching/presentation/cubit/match_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceiverBody extends StatefulWidget {
  const ReceiverBody({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  State<ReceiverBody> createState() => _ReceiverBodyState();
}

class _ReceiverBodyState extends State<ReceiverBody> {
  @override
  void initState() {
    super.initState();
    context.read<ReceiverCubit>().loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReceiverCubit, ReceiverState>(
      listener: (context, state) {
        if (state is ReceiverError) {
          showSnackBar('Failed', state.message, SnackbarType.error);
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(widget.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Requests', style: TextStyleHelper.h3(context)),

                SizedBox(height: widget.height * 0.02),

                if (state is ReceiverLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (state is ReceiverError)
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Icon(
                          Icons.error_outline,
                          color: AppColors.textMuted,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: TextStyleHelper.small(context),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: 'Retry',
                          height: 44,
                          backgroundColor: AppColors.primary,
                          isEnabled: true,
                          onPressed: () {
                            context.read<ReceiverCubit>().loadHistory();
                          },
                        ),
                      ],
                    ),
                  )
                else if (state is ReceiverLoaded && state.requests.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            color: AppColors.textMuted,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No requests yet',
                            style: TextStyleHelper.small(context),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (state is ReceiverLoaded)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.requests.length,
                    itemBuilder: (context, index) {
                      final req = state.requests[index];

                      return ActiveRequestsContainer(
                        height: widget.height,
                        width: widget.width,
                        isConfirmed:
                            req.status == 'Accepted' ||
                            req.status == 'Completed',
                        bloodType: req.bloodTypeDisplay,
                        situation: req.status,
                        time: req.relativeTime,
                        distance: '--',
                        requestId: req.requestId,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: widget.height * 0.03),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
