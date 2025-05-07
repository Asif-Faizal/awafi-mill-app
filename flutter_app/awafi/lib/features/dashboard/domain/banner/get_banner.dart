import 'banner_entity.dart';
import 'banner_repo.dart';

class GetBannersUseCase {
  final BannerRepository repository;

  GetBannersUseCase(this.repository);

  Future<List<BannerEntity>> call() async {
    return await repository.getBanners();
  }
}
class GetOfferBannersUseCase {
  final BannerRepository repository;

  GetOfferBannersUseCase(this.repository);

  Future<List<BannerEntity>> call() async {
    return await repository.getOfferBanners();
  }
}

class GetCollectionBannersUseCase {
  final BannerRepository repository;

  GetCollectionBannersUseCase(this.repository);

  Future<List<BannerEntity>> call() async {
    return await repository.getCollectionBanners();
  }
}
