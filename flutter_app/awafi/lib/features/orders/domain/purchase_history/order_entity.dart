class Order {
  final String id;
  final String user;
  final String transactionId;
  final List<Item> items;
  final double amount;
  final String cancellationReason;
  final String orderStatus;
  final ShippingAddress shippingAddress;
  final String createdAt;
  final String updatedAt;
  final String paymentMethod;
  final String currency;
  final double discountAmount;
  final String paymentStatus;
  final String trackingId;

  Order({
    required this.id,
    required this.user,
    required this.transactionId,
    required this.items,
    required this.amount,
    required this.cancellationReason,
    required this.orderStatus,
    required this.shippingAddress,
    required this.createdAt,
    required this.updatedAt,
    required this.paymentMethod,
    required this.currency,
    required this.discountAmount,
    required this.paymentStatus,
    required this.trackingId,
  });
}

class Item {
  final int quantity;

  Item({required this.quantity});
}

class ShippingAddress {
  final String fullName;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String postalCode;
  final String country;
  final String phone;

  ShippingAddress({
    required this.fullName,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.phone,
  });
}
