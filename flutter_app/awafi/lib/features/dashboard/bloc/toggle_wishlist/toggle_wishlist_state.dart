part of 'toggle_wishlist_bloc.dart';

abstract class ToggleWishlistState extends Equatable {
  @override
  List<Object> get props => [];
}

class WishlistInitial extends ToggleWishlistState {}

class WishlistItemAdded extends ToggleWishlistState {
  final ToggleWishlistItem item;

   WishlistItemAdded(this.item);

  @override
  List<Object> get props => [item];
}

class WishlistItemRemoved extends ToggleWishlistState {
  final ToggleWishlistItem item;

   WishlistItemRemoved(this.item);

  @override
  List<Object> get props => [item];
}
class WishlistItemLoading extends ToggleWishlistState {}

class WishlistError extends ToggleWishlistState {
  final String message;

  WishlistError(this.message);

  @override
  List<Object> get props => [message];
}