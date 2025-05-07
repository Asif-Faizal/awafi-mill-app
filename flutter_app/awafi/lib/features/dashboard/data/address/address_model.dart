// models/address_model.dart
import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String postalCode;
  final String country;

  const AddressModel({
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      city: json['city'],
      postalCode: json['postalCode'],
      country: json['country'],
    );
  }

  @override
  List<Object?> get props => [addressLine1, addressLine2, city, postalCode, country];
}
