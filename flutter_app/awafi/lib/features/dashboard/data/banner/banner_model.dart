class BannerModel {
  final String imageUrl;
  final String name;

  BannerModel({required this.imageUrl, required this.name});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      imageUrl: json['imageUrl'] as String,
      name: json['name'] as String,
    );
  }
}
