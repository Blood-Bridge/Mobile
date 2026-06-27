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
  String? city;
  String? bloodType;
  String? name;
  String? phone;
  String? nationalId;
  String? address;
  DateTime? dateOfBirth;
  double? weight;
  String? medicalHistory;
  //seter for i
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
  void update() {
    emit(Update());
  }

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? nationalIdValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your national id';
    } else {
      if (value.length != 14) {
        return 'Please enter a valid national id';
      }
    }
    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else {
      if (value.length != 11) {
        return 'Please enter a valid phone number';
      }
    }
    return null;
  }

  String? addressValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your address';
    }
    return null;
  }

  String? weightValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your weight';
    } else {
      if (double.tryParse(value) == null) {
        return 'Please enter a valid weight';
      } else {
        if (double.parse(value) <= 40) {
          return 'Please enter a valid weight';
        } else {
          weight = double.parse(value);
        }
      }
    }
    return null;
  }

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
    setI(1); //back end emplementaion
  }

  void secondScreenValidate({String? phone, String? address}) {
    try {
      this.phone = phone;
      this.address = address;
      setI(2);
      //back end emplementaion
    } catch (e) {
      emit(WrongData("Something went wrong"));
    }
  }

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
        "Empty feild",
        "please choose blood type",
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
      } else {
        if (id.birthDate != normalizeDate(dateOfBirth!) ||
            id.gender != (isMale == true ? 'ذكر' : 'أنثى')) {
          emit(WrongData("Wrong gender"));
          return;
        }
      }
      BloodType? bloodtype;
      switch (bloodType) {
        case "A+":
          bloodtype = BloodType.aPositive;
          break;
        case "A-":
          bloodtype = BloodType.aNegative;
          break;
        case "B+":
          bloodtype = BloodType.bPositive;
          break;
        case "B-":
          bloodtype = BloodType.bNegative;
          break;
        case "AB+":
          bloodtype = BloodType.abPositive;
          break;
        case "AB-":
          bloodtype = BloodType.abNegative;
          break;
        case "O+":
          bloodtype = BloodType.oPositive;
          break;
        case "O-":
          bloodtype = BloodType.oNegative;
      }
      final role = HiveHelper.getUserRole(); // now always lowercase
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
        role: role == "donor"
            ? UserRole.donor
            : role == "recipient"
            ? UserRole.recipient
            : UserRole.hospital,
        bloodType: bloodtype,
        governorate: city,
        dateOfBirth: dateOfBirth,
        weight: weight,
        medicalHistory: medicalHistory,
      );

      final body = registerModel.toJson();
      if (isGoogle) {
        body.remove('password');
        body.remove('confirmPassword');
      }

      final response = await DioHelper.postData(
        path: isGoogle ? "Auth/complete-google-profile" : "Auth/register",
        body: body,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data?['data'] ?? response.data;
        if (data != null) {
          if (data is Map<String, dynamic>) {
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
              print('❌ Failed to parse registration login response: $e');
            }
          } else if (data is String && data.isNotEmpty) {
            await SecureStorageService.saveToken(data);
          }
        }
        emit(Success());
      } else {
        final data = response.data;
        final message = data != null && data["message"] != null
            ? data["message"]
            : "Something went wrong";
        emit(WrongData(message));
      }
    } catch (e) {
      if (e is DioException) {
        Get.back();

        final data = e.response?.data;
        final message = data != null && data["message"] != null
            ? data["message"]
            : "Something went wrong";
        emit(WrongData(message));
      } else {
        emit(WrongData(e.toString()));
      }
    }
  }

  String normalizeDate(DateTime date) {
    return date.toIso8601String().split('T').first;
  }
}
