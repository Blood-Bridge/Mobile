import 'package:blood_bridge/core/l10n_ext.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/home/presentation/views/reciver/cubit/receiver_cubit.dart';
import 'package:blood_bridge/features/requests/presentation/views/detection_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SubmitRequestSheet extends StatefulWidget {
  final bool isEmergency;
  const SubmitRequestSheet({super.key, this.isEmergency = false});

  @override
  State<SubmitRequestSheet> createState() => _SubmitRequestSheetState();
}

class _SubmitRequestSheetState extends State<SubmitRequestSheet> {
  final _formKey = GlobalKey<FormState>();
  late String _urgencyLevel;
  String _bloodType = 'OPositive';
  int _quantity = 1;
  int _hospitalId = 1;
  final _medicalReportController = TextEditingController();

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

  final List<Map<String, dynamic>> _hospitals = [
    {'id': 1, 'name': 'Cairo General Hospital'},
    {'id': 2, 'name': 'Al Salam International Hospital'},
    {'id': 3, 'name': 'Demerdash Hospital'},
    {'id': 4, 'name': 'Aswan Hospital'},
  ];

  @override
  void initState() {
    _urgencyLevel = widget.isEmergency ? 'Critical' : 'Urgent';
    super.initState();
  }

  @override
  void dispose() {
    _medicalReportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isEmergency
                        ? context.l10n.emergencyRequest
                        : context.l10n.requestBlood,
                    style: TextStyleHelper.h2(context).copyWith(
                      color: widget.isEmergency
                          ? AppColors.primary
                          : Colors.white,
                    ),
                  ),
                  if (widget.isEmergency)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        context.l10n.highPriority,
                        style: TextStyleHelper.xs(context).copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n.urgencyLevel,
                style: TextStyleHelper.small(context),
              ),
              const SizedBox(height: 8),
              Row(
                children: ['Critical', 'Urgent', 'Normal'].map((level) {
                  final isSelected = _urgencyLevel == level;
                  Color color;
                  switch (level) {
                    case 'Critical':
                      color = AppColors.primary;
                      break;
                    case 'Urgent':
                      color = const Color(0xFFFF6900);
                      break;
                    default:
                      color = const Color(0xFF2B7FFF);
                  }
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _urgencyLevel = level),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withOpacity(0.2)
                              : AppColors.muted,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? color : AppColors.border,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            level,
                            style: TextStyleHelper.small(context).copyWith(
                              color: isSelected ? color : AppColors.textMuted,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.bloodType,
                          style: TextStyleHelper.small(context),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.muted,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _bloodType,
                              dropdownColor: AppColors.card,
                              isExpanded: true,
                              items: _bloodTypes.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(
                                    type,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null)
                                  setState(() => _bloodType = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.quantity,
                        style: TextStyleHelper.small(context),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.muted,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 16,
                              ),
                              onPressed: () {
                                if (_quantity > 1) {
                                  setState(() => _quantity--);
                                }
                              },
                            ),
                            Text(
                              '$_quantity',
                              style: TextStyleHelper.small(
                                context,
                              ).copyWith(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 16,
                              ),
                              onPressed: () {
                                setState(() => _quantity++);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n.hospital,
                style: TextStyleHelper.small(context),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.muted,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _hospitalId,
                    dropdownColor: AppColors.card,
                    isExpanded: true,
                    items: _hospitals.map((hosp) {
                      return DropdownMenuItem<int>(
                        value: hosp['id'] as int,
                        child: Text(
                          hosp['name'] as String,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _hospitalId = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n.medicalInformation,
                style: TextStyleHelper.small(context),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _medicalReportController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.muted,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  hintText: context
                      .l10n
                      .enterCaseDetailsEGPostOperativeCareAccidentLeukemiaTreatment,
                  hintStyle: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Please enter case details'
                    : null,
              ),
              const SizedBox(height: 32),
              BlocConsumer<ReceiverCubit, ReceiverState>(
                listener: (context, state) {
                  if (state is ReceiverSubmitSuccess) {
                    Get.back();
                    Get.to(
                      () => DetectionConfirmationScreen(
                        requestId: state.requestId,
                        detectedBloodType: state.detectedBloodType,
                        urgencyLevel: state.urgencyLevel,
                      ),
                    );
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
                  return SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<ReceiverCubit>().submitRequest(
                                  medicalReportText:
                                      _medicalReportController.text,
                                  bloodType: _bloodType,
                                  quantity: _quantity,
                                  urgencyLevel: _urgencyLevel,
                                  hospitalId: _hospitalId,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isEmergency
                            ? AppColors.primary
                            : AppColors.foreground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              widget.isEmergency
                                  ? context.l10n.submitEmergencyRequest
                                  : context.l10n.submitRequest,
                              style: TextStyleHelper.h3(context).copyWith(
                                color: widget.isEmergency
                                    ? AppColors.primaryForeground
                                    : AppColors.bg,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
