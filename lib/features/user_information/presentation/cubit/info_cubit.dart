import 'package:bloc/bloc.dart';
import 'package:blood_bridge/core/models/snackbar_type.dart';
import 'package:blood_bridge/core/models/user_role.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/core/services/secure_storage_service.dart';
import 'package:blood_bridge/core/widgets/custom_snackbar.dart';
import 'package:blood_bridge/features/auth/data/models/register_model.dart';
import 'package:blood_bridge/features/auth/data/models/login_response_model.dart';
import 'package:blood_bridge/features/map/presentation/services/location_service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:egyptian_id_parser/egyptian_id_parser.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

part 'info_state.dart';

class InfoCubit extends Cubit<InfoState> {
  InfoCubit() : super(InfoInitial());

  int i = 0;
  bool isMale = true;

  // ── Shared fields ──────────────────────────────────────────────────────────
  String? city;
  String? phone;
  String? address;

  // ── Donor / Recipient fields ───────────────────────────────────────────────
  String? bloodType;
  String? name;
  String? nationalId;
  DateTime? dateOfBirth;
  double? weight;
  String? medicalHistory;

  // ── Hospital fields ────────────────────────────────────────────────────────
  String? hospitalName;
  String? licenseNumber;
  String? hospitalType;
  int? capacity;
  bool? hasBloodBank;

  // ── Helpers ────────────────────────────────────────────────────────────────

  bool get isHospital => HiveHelper.getUserRole()!.toLowerCase() == 'hospital';

  void setI(int index) {
    i = index;
    emit(Update());
  }

  void changeGender() {
    isMale = !isMale;
    emit(SimpleUpdate());
  }

  void setBloodType(String value) {
    bloodType = value;
    emit(SimpleUpdate());
  }

  void setCity(String value) => city = value;

  void setHospitalType(String value) {
    hospitalType = value;
    emit(SimpleUpdate());
  }

  void setHasBloodBank(bool value) {
    hasBloodBank = value;
    emit(SimpleUpdate());
  }

  void update() => emit(Update());

  // ── Validators ─────────────────────────────────────────────────────────────

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your name';
    return null;
  }

  String? nationalIdValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your national id';
    if (value.length != 14) return 'Please enter a valid national id';
    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your phone number';
    if (value.length != 11) return 'Please enter a valid phone number';
    return null;
  }

  String? addressValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your address';
    return null;
  }

  String? weightValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your weight';
    if (double.tryParse(value) == null) return 'Please enter a valid weight';
    if (double.parse(value) <= 40) return 'Please enter a valid weight';
    weight = double.parse(value);
    return null;
  }

  // ── Step navigation ────────────────────────────────────────────────────────

  /// Step 1 — donor/recipient: name + national ID + DOB
  void firstScreenValidate({
    String? name,
    String? nationalId,
    DateTime? dateOfBirth,
  }) {
    this.name = name;
    this.nationalId = nationalId;
    this.dateOfBirth = dateOfBirth;
    if (dateOfBirth == null) {
      showSnackBar("Empty field", "Add your birthdate", SnackbarType.error);
      return;
    }
    setI(1);
  }

  /// Step 1 — hospital: hospital name + license + type
  void hospitalFirstScreenValidate({
    required String hospitalName,
    required String licenseNumber,
  }) {
    if (hospitalType == null) {
      showSnackBar(
        "Empty field",
        "Please select hospital type",
        SnackbarType.error,
      );
      return;
    }
    this.hospitalName = hospitalName;
    this.licenseNumber = licenseNumber;
    setI(1);
  }

  /// Step 2 — shared: phone + address + city
  void secondScreenValidate({String? phone, String? address}) {
    try {
      this.phone = phone;
      this.address = address;
      setI(2);
    } catch (e) {
      emit(WrongData("Something went wrong"));
    }
  }

  /// Step 3 — donor/recipient: blood type + weight + medical history
  void thirdScreenValidate({
    String? bloodType,
    String? city,
    double? weight,
    String? medicalHistory,
  }) async {
    this.bloodType = bloodType;
    this.city = city;
    this.weight = weight;
    this.medicalHistory = medicalHistory;

    if (bloodType == null) {
      showSnackBar(
        "Empty field",
        "Please choose blood type",
        SnackbarType.error,
      );
      return;
    }

    try {
      emit(Loading());
      var id = EgyptianIdParser(nationalId!);
      await HiveHelper.setUserDetails(name: name!, age: id.age.years);

      if (id.age.years < 18) {
        emit(UnderAge());
        return;
      }

      if (id.birthDate != normalizeDate(dateOfBirth!) ||
          id.gender != (isMale ? 'ذكر' : 'أنثى')) {
        emit(WrongData("Wrong gender"));
        return;
      }

      BloodType? bloodtype = _mapBloodType(bloodType);
      final split = name!.split(" ");
      LatLng locationService = await LocationService().getCurrentLatLng();
      final storedPassword = await SecureStorageService.getPassword();
      final isGoogle =
          storedPassword == null || FirebaseAuth.instance.currentUser != null;

      RegisterModel registerModel = RegisterModel(
        firstName: split[0],
        lastName: split.length > 1 ? split.sublist(1).join(" ") : split[0],
        email: HiveHelper.getUserEmail(),
        password: storedPassword,
        confirmPassword: storedPassword,
        latitude: locationService.latitude,
        longitude: locationService.longitude,
        nationalId: nationalId,
        phone: phone,
        donorRate: 0.0,
        role: _mapRole(),
        bloodType: bloodtype,
        governorate: city,
        dateOfBirth: dateOfBirth,
        weight: weight,
        medicalHistory: medicalHistory,
      );

      await _submitRegistration(registerModel, isGoogle);
    } catch (e) {
      _handleError(e);
    }
  }

  /// Step 3 — hospital: capacity + blood bank
  void hospitalThirdScreenValidate({required String capacityStr}) async {
    if (hasBloodBank == null) {
      showSnackBar(
        "Empty field",
        "Please select blood bank availability",
        SnackbarType.error,
      );
      return;
    }

    final cap = int.tryParse(capacityStr);
    if (cap == null || cap <= 0) {
      showSnackBar(
        "Invalid",
        "Please enter a valid capacity",
        SnackbarType.error,
      );
      return;
    }
    capacity = cap;

    try {
      emit(Loading());
      LatLng locationService = await LocationService().getCurrentLatLng();
      final storedPassword = await SecureStorageService.getPassword();
      final isGoogle =
          storedPassword == null || FirebaseAuth.instance.currentUser != null;

      // Build hospital registration body
      // Reuse RegisterModel name fields for hospital name
      RegisterModel registerModel = RegisterModel(
        firstName: hospitalName ?? '',
        lastName: '',
        email: HiveHelper.getUserEmail(),
        password: storedPassword,
        confirmPassword: storedPassword,
        latitude: locationService.latitude,
        longitude: locationService.longitude,
        nationalId: null,
        phone: phone,
        donorRate: 0.0,
        role: UserRole.hospital,
        bloodType: null,
        governorate: city,
        dateOfBirth: null,
        weight: null,
        medicalHistory: null,
      );

      // Add hospital-specific fields to body
      final body = registerModel.toJson();
      body['name'] = hospitalName;
      body['licenseNumber'] = licenseNumber;
      body['hospitalType'] = hospitalType;
      body['capacity'] = capacity;
      body['hasBloodBank'] = hasBloodBank;
      body['address'] = address;

      if (isGoogle) {
        body.remove('password');
        body.remove('confirmPassword');
      }

      final response = await DioHelper.postData(
        path: isGoogle ? "Auth/complete-google-profile" : "Auth/register",
        body: body,
      );

      await _handleResponse(response, registerModel);
    } catch (e) {
      _handleError(e);
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  UserRole _mapRole() {
    final role = HiveHelper.getUserRole()!.toLowerCase();
    if (role == 'donor') return UserRole.donor;
    if (role == 'recipient') return UserRole.recipient;
    return UserRole.hospital;
  }

  BloodType? _mapBloodType(String? bloodType) {
    switch (bloodType) {
      case "A+":
        return BloodType.aPositive;
      case "A-":
        return BloodType.aNegative;
      case "B+":
        return BloodType.bPositive;
      case "B-":
        return BloodType.bNegative;
      case "AB+":
        return BloodType.abPositive;
      case "AB-":
        return BloodType.abNegative;
      case "O+":
        return BloodType.oPositive;
      case "O-":
        return BloodType.oNegative;
      default:
        return null;
    }
  }

  Future<void> _submitRegistration(
    RegisterModel registerModel,
    bool isGoogle,
  ) async {
    final body = registerModel.toJson();
    if (isGoogle) {
      body.remove('password');
      body.remove('confirmPassword');
    }
    final response = await DioHelper.postData(
      path: isGoogle ? "Auth/complete-google-profile" : "Auth/register",
      body: body,
    );
    await _handleResponse(response, registerModel);
  }

  Future<void> _handleResponse(
    dynamic response,
    RegisterModel registerModel,
  ) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data?['data'] ?? response.data;
      if (data != null && data is Map<String, dynamic>) {
        try {
          final model = LoginResponseModel.fromJson(data);
          await SecureStorageService.saveAuthData(
            token: model.token,
            refreshToken: model.refreshToken,
            userId: model.userId,
            expiration: model.expiration,
          );
          await HiveHelper.setUserRole(
            email: registerModel.email ?? '',
            userType: model.role,
          );
        } catch (e) {
          debugPrint('❌ Failed to parse registration login response: $e');
        }
      } else if (data is String && data.isNotEmpty) {
        await SecureStorageService.saveToken(data);
      }
      emit(Success());
    } else {
      final message = _extractMessage(response.data);
      emit(WrongData(message));
    }
  }

  void _handleError(dynamic e) {
    if (e is DioException) {
      Get.back();
      emit(WrongData(_extractMessage(e.response?.data)));
    } else {
      emit(WrongData(e.toString()));
    }
  }

  String _extractMessage(dynamic data) {
    if (data is Map && data['message'] != null)
      return data['message'].toString();
    if (data is String && data.isNotEmpty) return data;
    return 'Something went wrong';
  }

  String normalizeDate(DateTime date) =>
      date.toIso8601String().split('T').first;
}
