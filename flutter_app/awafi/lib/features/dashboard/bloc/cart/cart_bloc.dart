import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/cart/cart_datasource.dart';
import '../../domain/cart/cart_entity.dart';
import '../../domain/cart/cart_repo.dart';
import '../../domain/cart/get_cart_items.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItems getCartItems;
  final CartRepository cartRepository;

  CartBloc(this.getCartItems, this.cartRepository) : super(CartInitial()) {
    on<FetchCartItems>((event, emit) async {
      emit(CartLoading());
      try {
        final items = await getCartItems();
        if (items.isEmpty) {
          emit(CartNotFound());
        } else {
          emit(CartLoaded(items));
        }
      } on UnauthenticatedException {
        emit(CartUnauthorized());
      } on CartNotFoundException {
        emit(CartNotFound());
      } catch (e) {
        if (e.toString().contains('403')) {
          emit(CartUnauthorized());
        } else {
          emit(CartNotFound());
        }
      }
    });


    on<UpdateCartQuantity>((event, emit) async {
      emit(CartLoading());
      try {
        final updatedItems = await cartRepository.updateCartQuantity(event.productId, event.variantId, event.quantity);
        emit(CartUpdated(updatedItems));
      } catch (e) {
        emit(CartError('Failed to update cart quantity'));
      }
    });

    on<RemoveCartItem>((event, emit) async {
      emit(CartLoading());
      try {
        final updatedItems = await cartRepository.removeCartItem(event.productId, event.variantId);
        emit(CartRemoved(updatedItems));
      } catch (e) {
        emit(CartError('Failed to remove item from cart'));
      }
    });
  }
}