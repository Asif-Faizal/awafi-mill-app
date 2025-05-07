class OrderModel {
  final String id;
  final String user;
  final String transactionId;
  final List<ItemModel> items;
  final double amount;
  final String cancellationReason;
  final String orderStatus;
  final ShippingAddressModel shippingAddress;
  final String createdAt;
  final String updatedAt;
  final String paymentMethod;
  final String currency;
  final double discountAmount;
  final String paymentStatus;
  final String trackingId;

  OrderModel({
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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'],
      user: json['user'],
      transactionId: json['transactionId'],
      items: (json['items'] as List)
          .map((item) => ItemModel.fromJson(item))
          .toList(),
      amount: json['amount'].toDouble(),
      cancellationReason: json['cancellationReason'],
      orderStatus: json['orderStatus'],
      shippingAddress: ShippingAddressModel.fromJson(json['shippingAddress']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      paymentMethod: json['paymentMethod'],
      currency: json['currency'],
      discountAmount: json['discountAmount'].toDouble(),
      paymentStatus: json['paymentStatus'],
      trackingId: json['trackingId'],
    );
  }
}

class ItemModel {
  final int quantity;

  ItemModel({required this.quantity});

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(quantity: json['quantity']);
  }
}

class ShippingAddressModel {
  final String fullName;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String postalCode;
  final String country;
  final String phone;

  ShippingAddressModel({
    required this.fullName,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.phone,
  });

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      fullName: json['fullName'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      city: json['city'],
      postalCode: json['postalCode'],
      country: json['country'],
      phone: json['phone'],
    );
  }
}
