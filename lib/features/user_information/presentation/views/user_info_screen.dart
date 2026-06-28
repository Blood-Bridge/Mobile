import 'package:blood_bridge/core/l10n_ext.dart';
import 'package:blood_bridge/core/models/snackbar_type.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_button.dart';
import 'package:blood_bridge/core/widgets/custom_snackbar.dart';
import 'package:blood_bridge/features/permissions/presntation/views/permissions_screen.dart';
import 'package:blood_bridge/features/user_information/presentation/cubit/info_cubit.dart';
import 'package:blood_bridge/features/user_information/presentation/views/widgets/info_body.dart';
import 'package:blood_bridge/features/user_information/presentation/views/widgets/user_info_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController medicalController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    nationalIdController.dispose();
    weightController.dispose();
    medicalController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InfoCubit>();
    final width = context.width;
    final height = context.height;

    return SafeArea(
      child: Scaffold(
        body: BlocListener<InfoCubit, InfoState>(
          listener: (context, state) {
            if (state is Update) {
              setState(() {});
            } else if (state is UnderAge) {
              showSnackBar(
                "Under Allowed Age",
                "Age less than 18",
                SnackbarType.error,
              );
              Get.back();
            } else if (state is WrongData) {
              showSnackBar("Wrong Data", state.message, SnackbarType.error);
              cubit.setI(0);
            } else if (state is Success) {
              showSnackBar(
                "Done",
                "Your information is saved",
                SnackbarType.success,
              );
              Get.to(PermissionsScreen());
            }
          },
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                UserInfoAppBar(width: width, height: height, cubit: cubit),
                Expanded(
                  child: InfoBody(
                    width: width,
                    height: height,
                    i: cubit.i,
                    nameController: nameController,
                    phoneController: phoneController,
                    addressController: addressController,
                    nationalIdController: nationalIdController,
                    weightController: weightController,
                    medicalController: medicalController,
                    cubit: cubit,
                  ),
                ),
                Container(
                  height: height * 0.12,
                  width: width,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    border: Border(
                      top: BorderSide(color: AppColors.border, width: 2),
                    ),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<InfoCubit, InfoState>(
                        builder: (context, state) {
                          return state is Loading
                              ? Center(
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                        color: AppColors.primary,
                                        size: width * 0.1,
                                      ),
                                )
                              : CustomButton(
                                  text: cubit.i == 2 ? "Submit" : "Next",
                                  height: height * 0.07,
                                  width: width,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (cubit.i == 0) {
                                        cubit.firstScreenValidate(
                                          name: nameController.text,
                                          nationalId: nationalIdController.text,
                                          dateOfBirth: cubit.dateOfBirth,
                                        );
                                      } else if (cubit.i == 1) {
                                        cubit.secondScreenValidate(
                                          phone: phoneController.text,
                                          address: addressController.text,
                                        );
                                      } else if (cubit.i == 2) {
                                        cubit.thirdScreenValidate(
                                          bloodType: cubit.bloodType,
                                          city: cubit.city,
                                          weight: cubit.weight,
                                          medicalHistory:
                                              medicalController.text,
                                        );
                                      }
                                    }
                                  },
                                );
                        },
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        context.l10n.yourInformationIsEncryptedAnd,
                        style: TextStyleHelper.small(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
