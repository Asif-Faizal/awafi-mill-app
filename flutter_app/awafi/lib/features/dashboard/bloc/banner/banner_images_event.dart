part of 'banner_images_bloc.dart';

abstract class BannerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadBannersEvent extends BannerEvent {}

class LoadOfferBannersEvent extends BannerEvent {}

class LoadCollectionBannersEvent extends BannerEvent {}