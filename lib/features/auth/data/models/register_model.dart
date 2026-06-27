import 'package:blood_bridge/core/models/user_role.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_model.freezed.dart';
part 'register_model.g.dart';

enum BloodType {
  @JsonValue('OPositive')
  oPositive,
  @JsonValue('ONegative')
  oNegative,
  @JsonValue('APositive')
  aPositive,
  @JsonValue('ANegative')
  aNegative,
  @JsonValue('BPositive')
  bPositive,
  @JsonValue('BNegative')
  bNegative,
  @JsonValue('ABPositive')
  abPositive,
  @JsonValue('ABNegative')
  abNegative,
}

@freezed
class RegisterModel with _$RegisterModel {
  const factory RegisterModel({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? confirmPassword,
    double? latitude,
    double? longitude,
    String? phone,
    BloodType? bloodType,
    UserRole? role,
    String? governorate,
    double? donorRate,
    String? nationalId,
    double? weight,
    String? medicalHistory,
    DateTime? dateOfBirth,
  }) = _RegisterModel;

  factory RegisterModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterModelFromJson(json);
}
