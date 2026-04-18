import 'dart:math';

import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class InfoBody extends StatelessWidget {
  InfoBody({super.key, required this.width, required this.height});
  final double width;
  final double height;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(width * 0.05),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Full Name *", style: TextStyleHelper.small(context)),
              CustomTextfield(
                text: "Enter your full name",
                controller: nameController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
