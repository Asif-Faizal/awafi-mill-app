// entities/address.dart
import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String postalCode;
  final String country;

  const Address({
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  @override
  List<Object?> get props => [addressLine1, addressLine2, city, postalCode, country];
}
