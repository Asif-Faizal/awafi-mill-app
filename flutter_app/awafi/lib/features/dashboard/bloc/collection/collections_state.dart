part of 'collections_bloc.dart';

abstract class CollectionState extends Equatable {
  @override
  List<Object> get props => [];
}

class CollectionInitial extends CollectionState {}

class CollectionLoading extends CollectionState {}

class CollectionLoaded extends CollectionState {
  final List<CollectionEntity> collections;

  CollectionLoaded({required this.collections});

  @override
  List<Object> get props => [collections];
}

class CollectionError extends CollectionState {
  final String message;

  CollectionError({required this.message});

  @override
  List<Object> get props => [message];
}