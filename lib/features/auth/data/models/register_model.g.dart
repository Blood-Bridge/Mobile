// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegisterModelImpl _$$RegisterModelImplFromJson(Map<String, dynamic> json) =>
    _$RegisterModelImpl(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      confirmPassword: json['confirmPassword'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      phone: json['phone'] as String?,
      bloodType: $enumDecodeNullable(_$BloodTypeEnumMap, json['bloodType']),
      role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']),
      governorate: json['governorate'] as String?,
      donorRate: (json['donorRate'] as num?)?.toDouble(),
      nationalId: json['nationalId'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      medicalHistory: json['medicalHistory'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
    );

Map<String, dynamic> _$$RegisterModelImplToJson(_$RegisterModelImpl instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'phone': instance.phone,
      'bloodType': _$BloodTypeEnumMap[instance.bloodType],
      'role': _$UserRoleEnumMap[instance.role],
      'governorate': instance.governorate,
      'donorRate': instance.donorRate,
      'nationalId': instance.nationalId,
      'weight': instance.weight,
      'medicalHistory': instance.medicalHistory,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
    };

const _$BloodTypeEnumMap = {
  BloodType.oPositive: 'OPositive',
  BloodType.oNegative: 'ONegative',
  BloodType.aPositive: 'APositive',
  BloodType.aNegative: 'ANegative',
  BloodType.bPositive: 'BPositive',
  BloodType.bNegative: 'BNegative',
  BloodType.abPositive: 'ABPositive',
  BloodType.abNegative: 'ABNegative',
};

const _$UserRoleEnumMap = {
  UserRole.recipient: 'Recipient',
  UserRole.donor: 'Donor',
  UserRole.hospital: 'Hospital',
};
