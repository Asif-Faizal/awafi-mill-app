import '../../domain/banner/banner_entity.dart';
import '../../domain/banner/banner_repo.dart';
import 'banner_datasource.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDataSource remoteDataSource;

  BannerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BannerEntity>> getBanners() async {
    final banners = await remoteDataSource.fetchBanners();
    return banners.map((banner) => BannerEntity(
      imageUrl: banner.imageUrl,
      name: banner.name,
    )).toList();
  }
    @override
  Future<List<BannerEntity>> getOfferBanners() async {
    final offerBanners = await remoteDataSource.fetchOfferBanners();
    return offerBanners.map((banner) => BannerEntity(
      imageUrl: banner.imageUrl,
      name: banner.name,
    )).toList();
  }

  @override
  Future<List<BannerEntity>> getCollectionBanners() async {
    final collectionBanners = await remoteDataSource.fetchCollectionBanners();
    return collectionBanners.map((banner) => BannerEntity(
      imageUrl: banner.imageUrl,
      name: banner.name,
    )).toList();
  }
}
