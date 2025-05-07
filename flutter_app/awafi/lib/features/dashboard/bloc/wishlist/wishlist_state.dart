part of 'wishlist_bloc.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<WishlistItemEntity> wishlistItems;

  const WishlistLoaded({required this.wishlistItems});

  @override
  List<Object> get props => [wishlistItems];
}

class WishlistFailure extends WishlistState {
  final String message;

  const WishlistFailure({required this.message});

  @override
  List<Object> get props => [message];
}
class UserNotLoggedIn extends WishlistState {
  @override
  List<Object> get props => [];
}