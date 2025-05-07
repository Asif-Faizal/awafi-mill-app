import 'package:equatable/equatable.dart';

class SubCategoryModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String mainCategory;
  final bool isListed;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubCategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.mainCategory,
    required this.isListed,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      mainCategory: json['mainCategory'],
      isListed: json['isListed'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  List<Object?> get props => [id, name, mainCategory];
}
