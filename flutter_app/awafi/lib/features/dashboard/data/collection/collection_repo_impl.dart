

import '../../domain/collection/collection_entity.dart';
import '../../domain/collection/collection_repo.dart';
import 'collection_datasource.dart';
import 'collection_model.dart';

class CollectionRepositoryImpl implements CollectionRepository {
  final CollectionRemoteDataSource remoteDataSource;

  CollectionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CollectionEntity>> getCollections() async {
    final List<CollectionModel> models = await remoteDataSource.fetchCollections();
    return models
        .map((model) => CollectionEntity(
              id: model.id,
              name: model.name,
              description: model.description,
              mainCategory: model.mainCategory,
              photo: model.photo,
              priority: model.priority,
            ))
        .toList();
  }
}
