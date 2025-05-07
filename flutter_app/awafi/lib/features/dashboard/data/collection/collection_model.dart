class CollectionModel {
  final String id;
  final String name;
  final String description;
  final String mainCategory;
  final bool isListed;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final String photo;
  final int priority;

  CollectionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.mainCategory,
    required this.isListed,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.photo,
    required this.priority,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      mainCategory: json['mainCategory'],
      isListed: json['isListed'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      photo: json['photo'],
      priority: json['priority'],
    );
  }
}
