import 'package:blood_bridge/core/l10n_ext.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_textfield.dart';
import 'package:blood_bridge/features/donations/presentation/cubit/donations_cubit.dart';
import 'package:blood_bridge/features/donations/presentation/cubit/donations_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CreateDonationScreen extends StatefulWidget {
  const CreateDonationScreen({super.key});

  @override
  State<CreateDonationScreen> createState() => _CreateDonationScreenState();
}

class _CreateDonationScreenState extends State<CreateDonationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _requestIdController = TextEditingController();
  final _hospitalIdController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _requestIdController.dispose();
    _hospitalIdController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.card,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppColors.bg,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
        title: Text('Log Donation Record', style: TextStyleHelper.h1(context)),
      ),
      body: BlocConsumer<DonationsCubit, DonationsState>(
        listener: (context, state) {
          if (state is DonationCreateSuccess) {
            Get.back();
            Get.snackbar(
              'Success',
              'Donation logged successfully',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            context.read<DonationsCubit>().fetchAllDonations();
          } else if (state is DonationsError) {
            Get.snackbar(
              'Error',
              state.message,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is DonationsLoading;
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: 16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Provide donation details to initiate verification and confirmation.',
                      style: TextStyleHelper.bodyMuted(context),
                    ),
                    SizedBox(height: height * 0.03),
                    CustomTextfield(
                      text: context.l10n.bloodRequestId,
                      controller: _requestIdController,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Request ID is required';
                        if (int.tryParse(v) == null)
                          return 'Must be a valid number';
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.02),
                    CustomTextfield(
                      text: context.l10n.hospitalId,
                      controller: _hospitalIdController,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Hospital ID is required';
                        if (int.tryParse(v) == null)
                          return 'Must be a valid number';
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.03),
                    Text(
                      'Donation Date',
                      style: TextStyleHelper.small(context),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate
                                  .toLocal()
                                  .toString()
                                  .split(' ')
                                  .first,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.06),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<DonationsCubit>().createDonation(
                                    bloodRequestId: int.parse(
                                      _requestIdController.text,
                                    ),
                                    hospitalId: int.parse(
                                      _hospitalIdController.text,
                                    ),
                                    donationDate: _selectedDate,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Log Donation',
                                style: TextStyleHelper.h3(
                                  context,
                                ).copyWith(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
