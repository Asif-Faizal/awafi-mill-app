// checkout_model.dart
import 'package:equatable/equatable.dart';

import '../../domain/checkout/checkout_entity.dart';

class CheckoutProductModel extends Equatable {
  final String productId;
  final String variantId;
  final int quantity;

  const CheckoutProductModel({
    required this.productId,
    required this.variantId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    'product': productId,
    'variant': variantId,
    'quantity': quantity,
  };

  @override
  List<Object?> get props => [productId, variantId, quantity];
}

class CheckoutModel extends Equatable {
  final double amount;
  final String currency;
  final String paymentMethod;
  final DateTime time;
  final List<CheckoutProductModel> products;
  final CheckoutShippingAddressModel shippingAddress;
  final String transactionId;
  final String paymentStatus;

  const CheckoutModel({
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.time,
    required this.products,
    required this.shippingAddress,
    required this.transactionId,
    required this.paymentStatus,
  });

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'currency': currency,
    'paymentMethod': paymentMethod,
    'time': time.toIso8601String(),
    'products': products.map((e) => e.toJson()).toList(),
    'shippingAddress': shippingAddress.toJson(),
    'transactionId': transactionId,
    'paymentStatus': paymentStatus,
  };

  @override
  List<Object?> get props => [amount, currency, paymentMethod, time, products, shippingAddress, transactionId, paymentStatus];
}

class CheckoutShippingAddressModel extends Equatable {
  final String fullName;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String postalCode;
  final String country;
  final String phone;

  const CheckoutShippingAddressModel({
    required this.fullName,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'addressLine1': addressLine1,
    'addressLine2': addressLine2,
    'city': city,
    'postalCode': postalCode,
    'country': country,
    'phone': phone,
  };
    factory CheckoutShippingAddressModel.fromEntity(CheckoutShippingAddress entity) {
    return CheckoutShippingAddressModel(
      fullName: entity.fullName,
      addressLine1: entity.addressLine1,
      addressLine2: entity.addressLine2,
      city: entity.city,
      postalCode: entity.postalCode,
      country: entity.country,
      phone: entity.phone,
    );
  }

  @override
  List<Object?> get props => [fullName, addressLine1, addressLine2, city, postalCode, country, phone];
}
