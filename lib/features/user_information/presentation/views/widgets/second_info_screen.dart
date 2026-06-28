import 'package:blood_bridge/constants.dart';
import 'package:blood_bridge/core/l10n_ext.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/widgets/custom_textfield.dart';
import 'package:blood_bridge/features/user_information/presentation/cubit/info_cubit.dart';
import 'package:flutter/material.dart';

class SecondInfoScreen extends StatelessWidget {
  const SecondInfoScreen({
    super.key,
    required this.height,
    required this.phoneController,
    required this.width,
    required this.addressController,
    required this.cubit,
  });

  final double height;
  final TextEditingController phoneController;
  final double width;
  final TextEditingController addressController;
  final InfoCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.phoneNumber, style: TextStyleHelper.small(context)),
        SizedBox(height: height * 0.01),
        CustomTextfield(
          prefixIcon: Icon(Icons.phone),
          text: context.l10n.text20123456789,
          controller: phoneController,
          validator: cubit.phoneValidator,
        ),
        SizedBox(height: height * 0.04),
        Text(context.l10n.address, style: TextStyleHelper.small(context)),
        SizedBox(height: height * 0.01),
        CustomTextfield(
          prefixIcon: Icon(Icons.location_on),
          text: context.l10n.enterYourAddress,
          controller: addressController,
          validator: cubit.addressValidator,
        ),
        SizedBox(height: height * 0.04),
        Text(context.l10n.city, style: TextStyleHelper.small(context)),
        SizedBox(height: height * 0.01),
        DropdownButtonFormField<String>(
          dropdownColor: Colors.black,
          hint: Text(
            cubit.city ?? "Enter your city",
            style: TextStyle(color: Colors.grey),
          ),
          style: TextStyle(color: Colors.white),
          items: egyptGovernorates.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (value) {
            cubit.setCity(value!);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black,
            contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade800),
            ),
          ),
        ),
      ],
    );
  }
}
