import 'package:blood_bridge/l10n/app_localizations.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/home/presentation/views/reciver/cubit/receiver_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class DetectionConfirmationScreen extends StatefulWidget {
  final int requestId;
  final String detectedBloodType;
  final String urgencyLevel;

  const DetectionConfirmationScreen({
    super.key,
    required this.requestId,
    required this.detectedBloodType,
    required this.urgencyLevel,
  });

  @override
  State<DetectionConfirmationScreen> createState() =>
      _DetectionConfirmationScreenState();
}

class _DetectionConfirmationScreenState
    extends State<DetectionConfirmationScreen> {
  late String _selectedBloodType;
  final List<String> _bloodTypes = [
    'OPositive',
    'ONegative',
    'APositive',
    'ANegative',
    'BPositive',
    'BNegative',
    'ABPositive',
    'ABNegative',
  ];

  @override
  void initState() {
    super.initState();
    // Normalize or match with list values
    _selectedBloodType = widget.detectedBloodType;
    if (!_bloodTypes.contains(_selectedBloodType)) {
      _selectedBloodType = 'OPositive';
    }
  }

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
        title: Text(
          AppLocalizations.of(context)!.confirm,
          style: TextStyleHelper.h1(context),
        ),
      ),
      body: BlocConsumer<ReceiverCubit, ReceiverState>(
        listener: (context, state) {
          if (state is ReceiverConfirmDetectionSuccess) {
            Get.back();
            Get.snackbar(
              'Success',
              'AI report confirmed and search initiated!',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            context.read<ReceiverCubit>().loadHistory();
          } else if (state is ReceiverError) {
            Get.snackbar(
              'Error',
              state.message,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ReceiverLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.online_prediction,
                      color: AppColors.primary,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.aiReportExtractedInformation,
                    style: TextStyleHelper.h2(context),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    AppLocalizations.of(
                      context,
                    )!.pleaseReviewTheDetailsExtracted,
                    style: TextStyleHelper.small(
                      context,
                    ).copyWith(color: AppColors.textMuted),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 36),
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
                      _buildInfoRow(
                        context,
                        label: AppLocalizations.of(context)!.urgencyLevel,
                        value: widget.urgencyLevel,
                        valueColor: widget.urgencyLevel == 'Critical'
                            ? AppColors.primary
                            : const Color(0xFFFF6900),
                      ),
                      const Divider(height: 32, color: Colors.grey),
                      Text(
                        AppLocalizations.of(context)!.verifiedBloodTypeRequired,
                        style: TextStyleHelper.small(
                          context,
                        ).copyWith(color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.muted,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedBloodType,
                            dropdownColor: AppColors.card,
                            isExpanded: true,
                            items: _bloodTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(
                                  _displayBloodType(type),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                            onChanged: isLoading
                                ? null
                                : (val) {
                                    if (val != null) {
                                      setState(() => _selectedBloodType = val);
                                    }
                                  },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<ReceiverCubit>().confirmDetection(
                              requestId: widget.requestId,
                              bloodType: _selectedBloodType,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            AppLocalizations.of(context)!.confirmSearchDonors,
                            style: TextStyleHelper.h3(
                              context,
                            ).copyWith(color: AppColors.primaryForeground),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyleHelper.small(
            context,
          ).copyWith(color: AppColors.textMuted),
        ),
        Text(
          value,
          style: TextStyleHelper.body(context).copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.white,
          ),
        ),
      ],
    );
  }

  String _displayBloodType(String type) {
    const map = {
      'OPositive': 'O+',
      'ONegative': 'O-',
      'APositive': 'A+',
      'ANegative': 'A-',
      'BPositive': 'B+',
      'BNegative': 'B-',
      'ABPositive': 'AB+',
      'ABNegative': 'AB-',
    };
    return map[type] ?? type;
  }
}
