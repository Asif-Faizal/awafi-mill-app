class ProductIndividualModel {
  final String id;
  final String name;
  final List<Description> descriptions;
  final List<String> images;
  final List<Variant> variants;
  final bool isListed;
  final String ean;
  final String sku;
  final bool? inCart;
  final bool? inWishlist;
  final double? averageRating;
  final int? totalReviews;
  // final Category mainCategoryData;
  // final Category subCategoryData;

  ProductIndividualModel({
    required this.id,
    required this.name,
    required this.descriptions,
    required this.images,
    required this.variants,
    required this.isListed,
    required this.ean,
    required this.sku,
    this.inCart,
    this.inWishlist,
    required this.averageRating,
    required this.totalReviews
    // required this.mainCategoryData,
    // required this.subCategoryData,
  });

  factory ProductIndividualModel.fromJson(Map<String, dynamic> json) {
    return ProductIndividualModel(
      id: json['_id'],
      name: json['name'],
      descriptions: (json['descriptions'] as List)
          .map((desc) => Description.fromJson(desc))
          .toList(),
      images: (json['images'] as List<dynamic>)
          .where((image) => image != null)  // Filter out null values
          .map((image) => image as String)
          .toList(),
      variants: (json['variants'] as List)
          .map((variant) => Variant.fromJson(variant))
          .toList(),
      isListed: json['isListed'],
      ean: json['ean'],
      sku: json['sku'],
      inCart: json['inCart'],
      inWishlist: json['inWishlist'],
      totalReviews: json['totalReviews'],
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      // mainCategoryData: Category.fromJson(json['MainCategoryData'][0]),
      // subCategoryData: Category.fromJson(json['SubCategoryData'][0]),
    );
  }
}

class Description {
  final String header;
  final String content;

  Description({required this.header, required this.content});

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
      header: json['header'],
      content: json['content'],
    );
  }
}

class Variant {
  final String id;
  final String weight;
  final double inPrice;
  final double outPrice;
  final int stockQuantity;

  Variant({
    required this.id,
    required this.weight,
    required this.inPrice,
    required this.outPrice,
    required this.stockQuantity,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['_id'],
      weight: json['weight'],
      inPrice: (json['inPrice'] as num).toDouble(),
      outPrice: (json['outPrice'] as num).toDouble(),
      stockQuantity: json['stockQuantity'],
    );
  }
}

class Category {
  final String id;
  final String name;
  final String description;
  final String photo;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.photo,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      photo: json['photo'],
    );
  }
}
