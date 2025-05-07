part of 'collections_bloc.dart';

abstract class CollectionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCollectionsEvent extends CollectionEvent {}