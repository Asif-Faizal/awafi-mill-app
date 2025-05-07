class AddAddressModel {
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String postalCode;
  final String country;

  AddAddressModel({
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'postalCode': postalCode,
      'country': country,
    };
  }

  factory AddAddressModel.fromJson(Map<String, dynamic> json) {
    return AddAddressModel(
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      city: json['city'],
      postalCode: json['postalCode'],
      country: json['country'],
    );
  }
}
