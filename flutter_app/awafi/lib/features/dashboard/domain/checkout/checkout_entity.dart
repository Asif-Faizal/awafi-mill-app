// checkout_entity.dart
import 'package:equatable/equatable.dart';

class CheckoutEntity extends Equatable {
  final double amount;
  final String currency;
  final String paymentMethod;
  final DateTime time;
  final List<CheckoutProductEntity> products;
  final CheckoutShippingAddress shippingAddress;
  final String transactionId;
  final String paymentStatus;

  const CheckoutEntity({
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.time,
    required this.products,
    required this.shippingAddress,
    required this.transactionId,
    required this.paymentStatus,
  });

  @override
  List<Object?> get props => [amount, currency, paymentMethod, time, products, shippingAddress, transactionId, paymentStatus];
}

class CheckoutProductEntity extends Equatable {
  final String productId;
  final String variantId;
  final int quantity;

  const CheckoutProductEntity({
    required this.productId,
    required this.variantId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, variantId, quantity];
}

class CheckoutShippingAddress extends Equatable {
  final String fullName;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String postalCode;
  final String country;
  final String phone;

  const CheckoutShippingAddress({
    required this.fullName,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.phone,
  });

  @override
  List<Object?> get props => [fullName, addressLine1, addressLine2, city, postalCode, country, phone];
}
