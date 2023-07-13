import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  final String refresh;
  final String access;

  LoginModel({
    required this.refresh,
    required this.access,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    refresh: json["refresh"]??'',
    access: json["access"]??'',
  );

  Map<String, dynamic> toJson() => {
    "refresh": refresh,
    "access": access,
  };
}
