import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/toggle_wishlist/add_to_wishlist.dart';
import '../../domain/toggle_wishlist/remove_item_from_wishlist.dart';
import '../../domain/toggle_wishlist/toggle_wishlist_entity.dart';

part 'toggle_wishlist_event.dart';
part 'toggle_wishlist_state.dart';
class ToggleWishlistBloc extends Bloc<ToggleWishlistEvent, ToggleWishlistState> {
  final AddItemToWishlist addItemToWishlistUseCase;
  final RemoveItemFromWishlist removeItemFromWishlistUseCase;

  ToggleWishlistBloc({
    required this.addItemToWishlistUseCase,
    required this.removeItemFromWishlistUseCase,
  }) : super(WishlistInitial()) {
    // Handling the AddItemToWishlistEvent
    on<AddItemToWishlistEvent>((event, emit) async {
      try {
        emit(WishlistItemLoading()); // Emit the loading state
        await addItemToWishlistUseCase.execute(event.item);
        emit(WishlistItemAdded(event.item)); // Pass the item
      } catch (e) {
        emit(WishlistError('Failed to add item to wishlist'));
      }
    });

    // Handling the RemoveItemFromWishlistEvent
    on<RemoveItemFromWishlistEvent>((event, emit) async {
      try {
        emit(WishlistItemLoading()); // Emit the loading state
        await removeItemFromWishlistUseCase.execute(event.item);
        emit(WishlistItemRemoved(event.item)); // Pass the item
      } catch (e) {
        emit(WishlistError('Failed to remove item from wishlist'));
      }
    });
  }
}
