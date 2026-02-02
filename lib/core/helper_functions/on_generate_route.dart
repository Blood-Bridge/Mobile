import 'package:blood_bridge/features/auth/presentation/views/login_view.dart';
import 'package:blood_bridge/features/on_boarding/presentaion/views/on_boarder_view.dart';
import 'package:blood_bridge/features/splash/presentaion/views/splash_view.dart';
import 'package:flutter/material.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(builder: (_) => const SplashView());
    case OnBoarderView.routeName:
      return MaterialPageRoute(builder: (_) => const OnBoarderView());
    case LoginView.routeName:
      return MaterialPageRoute(builder: (_) => const LoginView());
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('No route defined for this path')),
        ),
      );
  }
}
