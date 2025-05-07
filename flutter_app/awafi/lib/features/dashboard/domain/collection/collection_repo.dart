import 'collection_entity.dart';

abstract class CollectionRepository {
  Future<List<CollectionEntity>> getCollections();
}