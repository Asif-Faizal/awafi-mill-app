part of 'banner_images_bloc.dart';

abstract class BannerState extends Equatable {
  @override
  List<Object> get props => [];
}

class BannerInitial extends BannerState {}

class BannerLoading extends BannerState {}

class BannerLoaded extends BannerState {
  final List<BannerEntity> banners;

  BannerLoaded(this.banners);

  @override
  List<Object> get props => [banners];
}

class BannerError extends BannerState {
  final String message;

  BannerError(this.message);

  @override
  List<Object> get props => [message];
}