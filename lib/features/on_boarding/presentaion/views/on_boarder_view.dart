import 'package:blood_bridge/features/on_boarding/presentaion/views/widgets/on_boarder_view_body.dart';
import 'package:flutter/material.dart';

class OnBoarderView extends StatelessWidget {
  const OnBoarderView({super.key});
  static const String routeName = '/onBoarder';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: OnBoardingViewBody()));
  }
}
