import 'collection_entity.dart';
import 'collection_repo.dart';

class GetCollectionsUseCase {
  final CollectionRepository repository;

  GetCollectionsUseCase({required this.repository});

  Future<List<CollectionEntity>> call() async {
    return await repository.getCollections();
  }
}