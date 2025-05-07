class CollectionProductModel {
  final String id;
  final String sku;
  final String name;
  final List<DescriptionModel> descriptions;
  final bool isListed;
  final bool isDelete;
  final List<String> images;
  final List<VariantModel> variants;
  final double averageRating;
  final int totalReviews;

  CollectionProductModel({
    required this.id,
    required this.sku,
    required this.name,
    required this.descriptions,
    required this.isListed,
    required this.isDelete,
    required this.images,
    required this.variants,
    required this.averageRating,
    required this.totalReviews,
  });

  factory CollectionProductModel.fromJson(Map<String, dynamic> json) {
    return CollectionProductModel(
      id: json['_id'],
      sku: json['sku'],
      name: json['name'],
      descriptions: (json['descriptions'] as List)
          .map((desc) => DescriptionModel.fromJson(desc))
          .toList(),
      isListed: json['isListed'],
      isDelete: json['isDelete'],
      images: (json['images'] as List<dynamic>)
          .where((image) => image != null)  // Filter out null values
          .map((image) => image as String)
          .toList(),
      variants: (json['variants'] as List)
          .map((variant) => VariantModel.fromJson(variant))
          .toList(),
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: json['totalReviews'],
    );
  }
}

class DescriptionModel {
  final String header;
  final String content;

  DescriptionModel({required this.header, required this.content});

  factory DescriptionModel.fromJson(Map<String, dynamic> json) {
    return DescriptionModel(
      header: json['header'],
      content: json['content'],
    );
  }
}

class VariantModel {
  final String weight;
  final double inPrice;
  final double outPrice;
  final int stockQuantity;

  VariantModel({
    required this.weight,
    required this.inPrice,
    required this.outPrice,
    required this.stockQuantity,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      weight: json['weight'],
      inPrice: (json['inPrice'] as num).toDouble(),
      outPrice: (json['outPrice'] as num).toDouble()  ,
      stockQuantity: json['stockQuantity'],
    );
  }
}
