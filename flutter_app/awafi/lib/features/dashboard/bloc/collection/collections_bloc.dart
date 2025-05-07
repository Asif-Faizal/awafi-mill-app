import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/collection/collection_entity.dart';
import '../../domain/collection/get_collections.dart';

part 'collections_event.dart';
part 'collections_state.dart';


class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final GetCollectionsUseCase getCollectionsUseCase;

  CollectionBloc({required this.getCollectionsUseCase}) : super(CollectionInitial()) {
    on<FetchCollectionsEvent>((event, emit) async {
      emit(CollectionLoading());
      try {
        final collections = await getCollectionsUseCase();
        emit(CollectionLoaded(collections: collections));
      } catch (e) {
        emit(CollectionError(message: e.toString()));
      }
    });
  }
}