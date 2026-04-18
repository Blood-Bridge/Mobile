import 'package:bloc/bloc.dart';
import 'package:blood_bridge/core/models/user_role.dart';
import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/firebase/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  bool isEnabled = true;

  bool isValidEmail(String? email) {
    if (email == null) return false;
    return RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+\-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$",
    ).hasMatch(email);
  }

  bool isValidPassword(String? password) {
    if (password == null) return false;
    return RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
    ).hasMatch(password);
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    return isValidEmail(value.trim()) ? null : 'Enter a valid email';
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return isValidPassword(value) ? null : 'Enter a valid password';
  }

  //login
  void login({
    required String email,
    required String password,
    required UserRole userType,
  }) async {
    emit(LoginLoading());

    isEnabled = false;

    try {
      await Future.delayed(const Duration(seconds: 2));
      await HiveHelper.setToken(password);
      await HiveHelper.setUserRole(email: email, userType: userType.name);
      emit(LoginSuccess());
      switch (userType) {
        case UserRole.donor:
          //Get.offAll();
          break;
        case UserRole.recipient:
          //Get.offAll();
          break;
        case UserRole.hospital:
          // Get.offAll();
          break;
      }
      //remove this line
      isEnabled = true;
    } catch (e) {
      isEnabled = true;
      emit(LoginFailure());
    }
  }

  //login
  void signUp({
    required String email,
    required String password,
    required UserRole userType,
  }) async {
    emit(LoginLoading());

    isEnabled = false;

    try {
      await Future.delayed(const Duration(seconds: 2));
      await HiveHelper.setToken(password);
      await HiveHelper.setUserRole(email: email, userType: userType.name);
      emit(LoginSuccess());
      switch (userType) {
        case UserRole.donor:
          //Get.offAll();
          break;
        case UserRole.recipient:
          //Get.offAll();
          break;
        case UserRole.hospital:
          // Get.offAll();
          break;
      }
      //remove this line
      isEnabled = true;
    } catch (e) {
      isEnabled = true;
      emit(LoginFailure());
    }
  }

  void googleLogin(BuildContext context) async {
    emit(LoginLoading());
    isEnabled = false;
    try {
      await FirebaseAuthHelper.signInWithGoogle(context);
      isEnabled = true;
      emit(LoginSuccess());
    } catch (e) {
      isEnabled = true;
      emit(LoginFailure());
    }
  }
}
