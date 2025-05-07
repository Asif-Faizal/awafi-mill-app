import '../../domain/checkout/checkout_entity.dart';
import '../../domain/checkout/checkout_repo.dart';
import 'checkout_datasource.dart';
import 'checkout_model.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;

  CheckoutRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> checkout(CheckoutEntity checkoutEntity) async {
    try {
      await remoteDataSource.checkout(CheckoutModel(
        amount: checkoutEntity.amount,
        currency: checkoutEntity.currency,
        paymentMethod: checkoutEntity.paymentMethod,
        time: checkoutEntity.time,
        products: checkoutEntity.products
            .map((e) => CheckoutProductModel(
                productId: e.productId,
                variantId: e.variantId,
                quantity: e.quantity))
            .toList(),
        shippingAddress: CheckoutShippingAddressModel.fromEntity(checkoutEntity.shippingAddress),
        transactionId: checkoutEntity.transactionId,
        paymentStatus: checkoutEntity.paymentStatus,
      ));
    } on UnauthorisedException {
      throw UnauthorisedException();
    }
  }
}