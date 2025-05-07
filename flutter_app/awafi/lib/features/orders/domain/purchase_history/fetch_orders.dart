import 'order_entity.dart';
import 'order_repo.dart';

class FetchOrdersUseCase {
  final OrderRepository repository;

  FetchOrdersUseCase({required this.repository});

  Future<List<Order>> call(int page, int limit) {
    return repository.fetchOrders(page, limit);
  }
}