import 'package:equatable/equatable.dart';

class UserDataModel extends Equatable {
  final bool status;
  final UserProfileData profileData;

  const UserDataModel({required this.status, required this.profileData});

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      status: json['status'],
      profileData: UserProfileData.fromJson(json['profileData']),
    );
  }

  @override
  List<Object?> get props => [status, profileData];
}

class UserProfileData extends Equatable {
  final String name;
  final String email;
  final int phone;

  const UserProfileData({required this.name, required this.email, required this.phone});

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }


  @override
  List<Object?> get props => [name, email, phone];
}
