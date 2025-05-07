import 'banner_entity.dart';

abstract class BannerRepository {
  Future<List<BannerEntity>> getBanners();
  Future<List<BannerEntity>> getOfferBanners();
  Future<List<BannerEntity>> getCollectionBanners();
}
