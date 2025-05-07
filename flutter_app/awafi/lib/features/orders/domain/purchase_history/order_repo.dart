import 'order_entity.dart';

abstract class OrderRepository {
  Future<List<Order>> fetchOrders(int page, int limit);
}