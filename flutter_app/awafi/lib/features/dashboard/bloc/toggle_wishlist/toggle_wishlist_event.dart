part of 'toggle_wishlist_bloc.dart';

abstract class ToggleWishlistEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddItemToWishlistEvent extends ToggleWishlistEvent {
  final ToggleWishlistItem item;

  AddItemToWishlistEvent(this.item);

  @override
  List<Object> get props => [item];
}

class RemoveItemFromWishlistEvent extends ToggleWishlistEvent {
  final ToggleWishlistItem item;

  RemoveItemFromWishlistEvent(this.item);

  @override
  List<Object> get props => [item];
}