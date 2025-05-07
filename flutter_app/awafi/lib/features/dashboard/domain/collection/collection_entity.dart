import 'package:equatable/equatable.dart';

class CollectionEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String mainCategory;
  final String photo;
  final int priority;

  const CollectionEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.mainCategory,
    required this.photo,
    required this.priority,
  });

  @override
  List<Object> get props => [id, name, description, mainCategory, photo, priority];
}
