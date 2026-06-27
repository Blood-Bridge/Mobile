// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseModelImpl _$$LoginResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$LoginResponseModelImpl(
  token: json['token'] as String,
  refreshToken: json['refreshToken'] as String,
  role: json['role'] as String,
  userId: json['userId'] as int,
  expiration: DateTime.parse(json['expiration'] as String),
  needsProfileCompletion: json['needsProfileCompletion'] as bool? ?? false,
);

Map<String, dynamic> _$$LoginResponseModelImplToJson(
  _$LoginResponseModelImpl instance,
) => <String, dynamic>{
  'token': instance.token,
  'refreshToken': instance.refreshToken,
  'role': instance.role,
  'userId': instance.userId,
  'expiration': instance.expiration.toIso8601String(),
  'needsProfileCompletion': instance.needsProfileCompletion,
};
