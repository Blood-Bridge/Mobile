import 'package:bloc/bloc.dart' hide Transition;
import 'package:blood_bridge/core/models/snackbar_type.dart';
import 'package:blood_bridge/core/models/user_role.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/core/services/secure_storage_service.dart';
import 'package:blood_bridge/core/widgets/custom_snackbar.dart';
import 'package:blood_bridge/features/auth/data/models/login_response_model.dart';
import 'package:blood_bridge/features/auth/presentation/views/login_screen.dart';
import 'package:blood_bridge/features/auth/presentation/views/reset_password_screen.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/donor_screen.dart';
import 'package:blood_bridge/features/home/presentation/views/reciver/receiver_screen.dart';
import 'package:blood_bridge/features/user_information/presentation/views/user_info_screen.dart';
import 'package:blood_bridge/features/hospital_dashboard/presentation/views/hospital_dashboard_screen.dart';
import 'package:blood_bridge/features/welcome/presentation/views/welcome_view.dart';
import 'package:blood_bridge/firebase/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  bool isEnabled = true;

  bool isValidEmail(String? email) {
    if (email == null) return false;
    return GetUtils.isEmail(email);
  }

  bool isValidPassword(String? password) {
    if (password == null) return false;
    return password.length >= 8;
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    return isValidEmail(value.trim()) ? null : 'Enter a valid email';
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return isValidPassword(value) ? null : 'Enter a valid password';
  }

  /// Route to the correct home screen based on role string from Hive/API.
  void _navigateByRole(String? roleStr) {
    final role = UserRole.fromString(roleStr);
    switch (role) {
      case UserRole.donor:
        Get.offAll(
          () => const DonorScreen(),
          transition: Transition.topLevel,
          duration: const Duration(milliseconds: 400),
        );
        break;
      case UserRole.recipient:
        Get.offAll(
          () => const ReceiverScreen(),
          transition: Transition.topLevel,
          duration: const Duration(milliseconds: 400),
        );
        break;
      case UserRole.hospital:
        Get.offAll(
          () => const HospitalDashboardScreen(),
          transition: Transition.topLevel,
          duration: const Duration(milliseconds: 400),
        );
        break;
      default:
        Get.to(
          () => UserInfoScreen(),
          transition: Transition.topLevel,
          duration: const Duration(milliseconds: 400),
        );
    }
  }

  // ── Login ────────────────────────────────────────────────────────────────
  void login({
    required String email,
    required String password,
    required UserRole userType,
  }) async {
    emit(LoginLoading());
    isEnabled = false;

    try {
      final response = await DioHelper.postData(
        path: "Auth/login",
        body: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        final model = LoginResponseModel.fromJson(response.data["data"]);

        // Persist session
        await HiveHelper.setUserRole(email: email, userType: model.role);
        await SecureStorageService.saveAuthData(
          token: model.token,
          refreshToken: model.refreshToken,
          userId: model.userId,
          expiration: model.expiration,
        );
        await SecureStorageService.deletePassword();
        final r = await DioHelper.getData(path: "Users/profile");
        HiveHelper.setUserDetails(name: r.data["data"]["fullName"], age: 20);
        emit(LoginSuccess());
        // Navigate using server-returned role (authoritative)
        _navigateByRole(model.role);
      } else {
        emit(LoginFailure(response.data["message"] ?? "Login failed"));
      }
    } on DioException catch (e) {
      final message = e.response?.data?["message"] ?? "Something went wrong";
      emit(LoginFailure(message));
    } catch (e) {
      emit(LoginFailure("${e.toString()}"));
    } finally {
      isEnabled = true;
    }
  }

  // ── Sign Up (email + password check only — full registration in InfoCubit) ─
  void signUp({
    required String email,
    required String password,
    required UserRole userType,
  }) async {
    emit(LoginLoading());
    isEnabled = false;

    try {
      final isRegistered = await DioHelper.getData(
        path: "Auth/check-email",
        queryParameters: {"email": email},
      );

      if (isRegistered.data['data'] == true) {
        emit(LoginFailure("This email is already registered"));
        Get.to(
          () => LoginScreen(),
          transition: Transition.topLevel,
          duration: const Duration(milliseconds: 400),
        );
        return;
      }

      await HiveHelper.setUserRole(email: email, userType: userType.name);
      await SecureStorageService.savePassword(password);
      emit(SignUpSuccess());
    } on DioException catch (e) {
      final message = e.response?.data?["message"] ?? "Something went wrong";
      emit(LoginFailure(message));
    } catch (_) {
      emit(LoginFailure("Unexpected error"));
    } finally {
      isEnabled = true;
    }
  }

  // ── Google Login ─────────────────────────────────────────────────────────
  void googleLogin(BuildContext context) async {
    emit(LoginLoading());
    isEnabled = false;

    try {
      await FirebaseAuthHelper.signOutUser(context);
      final idToken = await FirebaseAuthHelper.signInWithGoogle(context);

      if (idToken == null) {
        emit(LoginFailure("Couldn't Sign in with Google"));
        return;
      }

      final response = await DioHelper.postData(
        path: "Auth/google",
        body: {"idToken": idToken},
      );

      if (response.statusCode != 200) {
        final message =
            response.data?["message"] ?? "Couldn't Sign in with Google";
        emit(LoginFailure(message));
        return;
      }

      final model = LoginResponseModel.fromJson(response.data["data"]);

      if (model.needsProfileCompletion) {
        // Save auth data even if profile is not completed yet so that complete-google-profile is authorized!
        await SecureStorageService.saveAuthData(
          token: model.token,
          refreshToken: model.refreshToken,
          userId: model.userId,
          expiration: model.expiration,
        );
        final email = FirebaseAuth.instance.currentUser?.email ?? '';
        await HiveHelper.setUserRole(email: email, userType: model.role);

        // New Google user — complete profile before accessing home
        Get.offAll(
          () => const UserInfoScreen(),
          transition: Transition.topLevel,
          duration: const Duration(milliseconds: 400),
        );
      } else {
        await SecureStorageService.saveAuthData(
          token: model.token,
          refreshToken: model.refreshToken,
          userId: model.userId,
          expiration: model.expiration,
        );
        final email = FirebaseAuth.instance.currentUser?.email ?? '';
        await HiveHelper.setUserRole(email: email, userType: model.role);

        emit(GoogleAuthSuccess());

        _navigateByRole(model.role);
      }
    } on DioException catch (e) {
      final message = e.response?.data?["message"] ?? e.toString();
      emit(LoginFailure(message));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    } finally {
      isEnabled = true;
    }
  }

  // ── Logout ───────────────────────────────────────────────────────────────
  void logout(BuildContext context) async {
    try {
      await DioHelper.postData(path: "Auth/logout");
    } catch (_) {
      // Best-effort — always clear local state even if server call fails
    }
    await FirebaseAuthHelper.signOutUser(context);
    await SecureStorageService.clear();
    await HiveHelper.clearUserData();
    isEnabled = true;
    emit(AuthInitial());
    Get.offAll(() => WelcomeView());
  }

  // ── Forgot Password ──────────────────────────────────────────────────────
  void forgetPassword(String? email) async {
    emit(LoginLoading());

    if (email == null || email.trim().isEmpty) {
      showSnackBar("Error", "Please Enter your Email", SnackbarType.error);
      emit(LoginFailure("Email is required"));
      return;
    }

    try {
      final response = await DioHelper.postData(
        path: "Auth/forgot-password",
        body: {"email": email.trim()},
      );

      if (response.statusCode == 200) {
        showSnackBar(
          "Success",
          "Check your email",
          SnackbarType.custom,
          icon: Icons.email,
        );
        emit(LoginSuccess());
        Get.to(() => ResetPasswordScreen(email: email.trim()));
      } else {
        emit(
          LoginFailure(
            response.data["message"] ?? "Failed to send reset email",
          ),
        );
      }
    } on DioException catch (e) {
      final message = e.response?.data?["message"] ?? "Something went wrong";
      showSnackBar("Error", message, SnackbarType.error);
      emit(LoginFailure(message));
    } catch (_) {
      emit(LoginFailure("Unexpected Error"));
    }
  }

  // ── Reset Password ───────────────────────────────────────────────────────
  void resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(LoginLoading());
    try {
      final response = await DioHelper.postData(
        path: "Auth/reset-password",
        body: {
          "email": email.trim(),
          "token": token.trim(),
          "newPassword": newPassword,
          "confirmPassword": confirmPassword,
        },
      );

      if (response.statusCode == 200) {
        showSnackBar(
          "Success",
          "Password reset successfully",
          SnackbarType.custom,
          icon: Icons.check,
        );
        emit(LoginSuccess());
        Get.offAll(() => LoginScreen());
      } else {
        emit(
          LoginFailure(response.data["message"] ?? "Failed to reset password"),
        );
      }
    } on DioException catch (e) {
      final message = e.response?.data?["message"] ?? "Something went wrong";
      showSnackBar("Error", message, SnackbarType.error);
      emit(LoginFailure(message));
    } catch (_) {
      emit(LoginFailure("Unexpected Error"));
    }
  }
}
