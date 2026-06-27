import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/donations/data/models/donation_model.dart';
import 'package:blood_bridge/features/donations/presentation/cubit/donations_cubit.dart';
import 'package:blood_bridge/features/donations/presentation/cubit/donations_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class EditDonationScreen extends StatefulWidget {
  final DonationModel donation;
  const EditDonationScreen({super.key, required this.donation});

  @override
  State<EditDonationScreen> createState() => _EditDonationScreenState();
}

class _EditDonationScreenState extends State<EditDonationScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDate;
  late String _confirmationStatus;

  final List<String> _statuses = [
    'Pending',
    'DonorConfirmed',
    'PatientConfirmed',
    'Confirmed',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.donation.donationDate;
    _confirmationStatus = widget.donation.confirmationStatus;
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
          icon: Icon(Icons.arrow_back_ios, color: AppColors.foreground, size: 18),
          onPressed: () => Get.back(),
        ),
        title: Text('Edit Donation Log', style: TextStyleHelper.h1(context)),
      ),
      body: BlocConsumer<DonationsCubit, DonationsState>(
        listener: (context, state) {
          if (state is DonationUpdateSuccess) {
            Get.back();
            Get.snackbar('Success', 'Donation updated successfully',
                backgroundColor: Colors.green, colorText: Colors.white);
            context.read<DonationsCubit>().fetchDonationById(widget.donation.donationProcessId);
          } else if (state is DonationsError) {
            Get.snackbar('Error', state.message,
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        },
        builder: (context, state) {
          final isLoading = state is DonationsLoading;
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Donation Process #${widget.donation.donationProcessId}', style: TextStyleHelper.h3(context)),
                    SizedBox(height: height * 0.03),
                    Text('Confirmation Status', style: TextStyleHelper.small(context)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _confirmationStatus,
                          dropdownColor: AppColors.card,
                          isExpanded: true,
                          items: _statuses.map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(status, style: const TextStyle(color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _confirmationStatus = val);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Text('Donation Date', style: TextStyleHelper.small(context)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate.toLocal().toString().split(' ').first,
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Icon(Icons.calendar_today, color: AppColors.primary),
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
                                context.read<DonationsCubit>().updateDonation(
                                      id: widget.donation.donationProcessId,
                                      donationDate: _selectedDate,
                                      confirmationStatus: _confirmationStatus,
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
                                'Save Changes',
                                style: TextStyleHelper.h3(context).copyWith(
                                  color: Colors.white,
                                ),
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
