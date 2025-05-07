import '../../domain/purchase_history/order_entity.dart';
import '../../domain/purchase_history/order_repo.dart';
import 'order_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource dataSource;

  OrderRepositoryImpl({required this.dataSource});

  @override
  Future<List<Order>> fetchOrders(int page, int limit) async {
    final orderModels = await dataSource.fetchOrders(page, limit);
    return orderModels.map((orderModel) => Order(
      id: orderModel.id,
      user: orderModel.user,
      transactionId: orderModel.transactionId,
      items: orderModel.items.map((item) => Item(quantity: item.quantity)).toList(),
      amount: orderModel.amount,
      cancellationReason: orderModel.cancellationReason,
      orderStatus: orderModel.orderStatus,
      shippingAddress: ShippingAddress(
        fullName: orderModel.shippingAddress.fullName,
        addressLine1: orderModel.shippingAddress.addressLine1,
        addressLine2: orderModel.shippingAddress.addressLine2,
        city: orderModel.shippingAddress.city,
        postalCode: orderModel.shippingAddress.postalCode,
        country: orderModel.shippingAddress.country,
        phone: orderModel.shippingAddress.phone,
      ),
      createdAt: orderModel.createdAt,
      updatedAt: orderModel.updatedAt,
      paymentMethod: orderModel.paymentMethod,
      currency: orderModel.currency,
      discountAmount: orderModel.discountAmount,
      paymentStatus: orderModel.paymentStatus,
      trackingId: orderModel.trackingId,
    )).toList();
  }
}