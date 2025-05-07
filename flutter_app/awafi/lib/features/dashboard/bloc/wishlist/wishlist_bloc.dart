import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/wishlist/wishlist_datasource.dart';
import '../../domain/wishlist/get_wishlist.dart';
import '../../domain/wishlist/wishlist_entity.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final GetWishlistItemsUseCase getWishlistItemsUseCase;

  WishlistBloc({required this.getWishlistItemsUseCase}) : super(WishlistInitial()) {
    on<LoadWishlistItems>(_onLoadWishlistItems);
  }

  Future<void> _onLoadWishlistItems(
      LoadWishlistItems event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading()); // Emit loading state

    try {
      final wishlistItems = await getWishlistItemsUseCase();
      emit(WishlistLoaded(wishlistItems: wishlistItems)); // Emit loaded state
    } on UnauthenticatedException {
      emit(UserNotLoggedIn()); // Emit not logged in state
    } catch (e) {
      emit(WishlistFailure(message: e.toString())); // Emit error state
    }
  }
}
