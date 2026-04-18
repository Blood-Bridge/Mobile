import 'package:blood_bridge/core/models/user_role.dart';
import 'package:blood_bridge/features/auth/data/models/login_model.dart';
import 'package:blood_bridge/features/auth/data/models/register_model.dart';

main() {
  RegisterModel register = const RegisterModel();
  LoginModel login = const LoginModel(email: 'email', password: 'password');
  print(login);
  print("ddddddddddddddddddddddddddddddd");
  print(login.toJson());
  login = login.copyWith(email: 'email11', password: 'password11');
  print(login);
  print("ddddddddddddddddddddddddddddddd");
  print(login.toJson());
  register = register.copyWith(
    firstName: 'Youssef',
    lastName: 'Esmail',
    email: 'youssef@email.com',
    password: '123456',
  );
  register = register.copyWith(
    phone: '01018872983',
    governorate: 'Cairo',
    bloodType: BloodType.oPositive,
    role: UserRole.donor,
  );
  register = register.copyWith(
    phone: '01018872983',
    governorate: 'Cairo',
    bloodType: BloodType.oPositive,
    role: UserRole.donor,
  );
  register = register.copyWith(latitude: 30.0444, longitude: 31.2357);
}
