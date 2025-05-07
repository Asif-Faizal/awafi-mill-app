// category_entity.dart
import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String photo;
  final String description;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.photo,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, photo, description];
}
