// category_model.dart
class CategoryModel {
  final String id;
  final String name;
  final String photo;
  final String description;
  final bool isListed;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.photo,
    required this.description,
    required this.isListed,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'],
      name: json['name'],
      photo: json['photo'],
      description: json['description'],
      isListed: json['isListed'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
