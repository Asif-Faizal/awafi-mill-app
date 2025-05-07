import '../../domain/addCart/add_cart_entity.dart';
import '../../domain/addCart/add_cart_repo.dart';
import 'add_cart_datasource.dart';
import 'add_cart_model.dart';

class AddCartRepoImpl implements AddCartRepo {
  final AddCartDatasource remoteDataSource;

  AddCartRepoImpl({required this.remoteDataSource});

  @override
  Future<void> addCartItem(AddCartItem cartItem) async {
    final model = AddCartItemModel(
      productId: cartItem.productId,
      variantId: cartItem.variantId,
      quantity: cartItem.quantity,
    );
    await remoteDataSource.addCartItem(model);
  }
}