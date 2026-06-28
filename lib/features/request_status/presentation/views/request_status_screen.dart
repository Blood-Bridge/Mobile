import 'package:blood_bridge/core/l10n_ext.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/request_status/data/models/request_status_model.dart';
import 'package:blood_bridge/features/request_status/presentation/cubit/request_status_cubit.dart';
import 'package:blood_bridge/features/request_status/presentation/cubit/request_status_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

/// Use this widget when navigating from a context that already has
/// [RequestStatusCubit] in the tree (e.g. main.dart MultiBlocProvider).
///
/// If you navigate with Get.to() the inherited cubit is NOT passed to the
/// new route automatically. Use [RequestStatusScreen.withOwnCubit] instead
/// to create a fresh cubit for the route.
class RequestStatusScreen extends StatefulWidget {
  final int requestId;
  const RequestStatusScreen({super.key, required this.requestId});

  /// Navigate to this screen with its own [RequestStatusCubit].
  /// Use this from DonorBody / RequestsContainer when calling Get.to().
  static void navigate(int requestId) {
    Get.to(
      () => BlocProvider(
        create: (_) => RequestStatusCubit()..getRequestStatus(requestId),
        child: _RequestStatusBody(requestId: requestId),
      ),
    );
  }

  @override
  State<RequestStatusScreen> createState() => _RequestStatusScreenState();
}

class _RequestStatusScreenState extends State<RequestStatusScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RequestStatusCubit>().getRequestStatus(widget.requestId);
  }

  @override
  Widget build(BuildContext context) =>
      _RequestStatusBody(requestId: widget.requestId);
}

// ── Shared body (used by both routes) ────────────────────────────────────────

class _RequestStatusBody extends StatelessWidget {
  final int requestId;
  const _RequestStatusBody({required this.requestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.foreground,
            size: 18,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(context.l10n.status, style: TextStyleHelper.h1(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<RequestStatusCubit>().getRequestStatus(requestId),
            tooltip: context.l10n.refresh,
          ),
        ],
      ),
      body: BlocBuilder<RequestStatusCubit, RequestStatusState>(
        builder: (context, state) {
          if (state is RequestStatusLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RequestStatusError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 54,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: TextStyleHelper.body(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context
                          .read<RequestStatusCubit>()
                          .getRequestStatus(requestId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                      ),
                      child: Text(
                        context.l10n.retry,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is RequestStatusLoaded) {
            final model = state.requestStatus;
            debugPrint('🔥 STATUS FROM CUBIT: "${model.status}"');
            debugPrint('🔥 Current Index: ${model.currentIndex}');

            final isCancelled = model.status.toLowerCase() == 'cancelled';
            final isExpired = model.status.toLowerCase() == 'expired';

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<RequestStatusCubit>().getRequestStatus(
                  requestId,
                );
              },
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Current status card ──────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${context.l10n.request} #$requestId',
                            style: TextStyleHelper.h2(context),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                '${context.l10n.status}: ',
                                style: TextStyleHelper.small(
                                  context,
                                ).copyWith(color: AppColors.textMuted),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: (isCancelled || isExpired)
                                      ? Colors.red.withOpacity(0.15)
                                      : AppColors.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  model.status,
                                  style: TextStyleHelper.small(context)
                                      .copyWith(
                                        color: (isCancelled || isExpired)
                                            ? Colors.red
                                            : AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      context.l10n.timeline,
                      style: TextStyleHelper.h3(context),
                    ),
                    const SizedBox(height: 20),

                    if (isCancelled || isExpired)
                      _buildTerminalStateCard(context, model.status)
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: RequestStatusModel.statusTimeline.length,
                        itemBuilder: (context, index) {
                          final step = RequestStatusModel.statusTimeline[index];
                          final isCompleted = model.isStepCompleted(step);
                          final isActive = model.isStepActive(step);

                          return _buildTimelineStep(
                            context: context,
                            stepTitle: _getStepTitle(step),
                            stepDescription: _getStepDescription(step),
                            isCompleted: isCompleted,
                            isActive: isActive,
                            isLast:
                                index ==
                                RequestStatusModel.statusTimeline.length - 1,
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildTerminalStateCard(BuildContext context, String status) {
    final isCancelled = status.toLowerCase() == 'cancelled';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cancel, color: Colors.red, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCancelled
                      ? context.l10n.requestCancelled
                      : context.l10n.requestExpired,
                  style: TextStyleHelper.h3(
                    context,
                  ).copyWith(color: Colors.red),
                ),
                const SizedBox(height: 4),
                Text(
                  isCancelled
                      ? context.l10n.requestCancelledDescription
                      : 'This blood request expired because no compatible donors responded within the required timeframe.',
                  style: TextStyleHelper.small(
                    context,
                  ).copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required BuildContext context,
    required String stepTitle,
    required String stepDescription,
    required bool isCompleted,
    required bool isActive,
    required bool isLast,
  }) {
    Color dotColor = AppColors.border;
    if (isActive) {
      dotColor = AppColors.primary;
    } else if (isCompleted) {
      dotColor = Colors.green;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: dotColor.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: dotColor, width: isActive ? 4 : 2.5),
              ),
              child: isCompleted && !isActive
                  ? const Center(
                      child: Icon(Icons.check, size: 14, color: Colors.green),
                    )
                  : isActive
                  ? const Center(
                      child: SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 52,
                color: isCompleted ? Colors.green : AppColors.border,
                margin: const EdgeInsets.only(top: 8),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stepTitle,
                style: TextStyleHelper.body(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: isActive
                      ? AppColors.primary
                      : (isCompleted ? Colors.white : AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stepDescription,
                style: TextStyleHelper.xs(context).copyWith(
                  color: isActive ? Colors.white70 : AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  String _getStepTitle(String status) {
    switch (status) {
      case 'Pending':
        return 'Request Created';
      case 'Analyzing':
        return 'AI Analysis';
      case 'Open':
        return 'Searching Donors';
      case 'Accepted':
        return 'Donor Found';
      case 'OnTheWay':
        return 'Donor On The Way';
      case 'Arrived':
        return 'Donor Arrived';
      case 'Completed':
        return 'Donation Completed';
      default:
        return status;
    }
  }

  String _getStepDescription(String status) {
    switch (status) {
      case 'Pending':
        return 'Your blood request was successfully submitted to the platform.';
      case 'Analyzing':
        return 'Our AI models are extracting details and assessing eligibility from your medical report.';
      case 'Open':
        return 'Active search initialized. Compatible donors in your governorate have been notified.';
      case 'Accepted':
        return 'A compatible donor has accepted your request. Details are being coordinated.';
      case 'OnTheWay':
        return 'The donor is currently on the way to the hospital.';
      case 'Arrived':
        return 'The donor has arrived at the hospital.';
      case 'Completed':
        return 'The donation process is finished successfully. Thank you for using Blood Bridge!';
      default:
        return '';
    }
  }
}
