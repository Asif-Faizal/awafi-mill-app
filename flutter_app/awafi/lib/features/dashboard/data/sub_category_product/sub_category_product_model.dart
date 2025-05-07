import 'package:equatable/equatable.dart';

class SubCategoryProductModel extends Equatable {
  final String id;
  final String sku;
  final String name;
  final String description;
  final List<String> images;
  final List<Variant> variants;
  // final SubCategoryPhoto subCategoryPhoto;

  const SubCategoryProductModel({
    required this.id,
    required this.sku,
    required this.name,
    required this.description,
    required this.images,
    required this.variants,
    // required this.subCategoryPhoto,
  });

  factory SubCategoryProductModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryProductModel(
      id: json['_id'],
      sku: json['sku'],
      name: json['name'],
      description: json['descriptions'][0]['content'],
      images: (json['images'] as List<dynamic>)
          .where((image) => image != null)  // Filter out null values
          .map((image) => image as String)
          .toList(),
      variants: (json['variants'] as List)
          .map((variant) => Variant.fromJson(variant))
          .toList(),
      // subCategoryPhoto: SubCategoryPhoto.fromJson(json['SubCategoryData'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object> get props => [id, sku, name, description, images, variants];
}

class SubCategoryPhoto {
  final String photo;

  SubCategoryPhoto({required this.photo});

  factory SubCategoryPhoto.fromJson(Map<String, dynamic> json) {
    return SubCategoryPhoto(
      photo: json['photo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo': photo,
    };
  }
}

class Variant extends Equatable {
  final String id;
  final String weight;
  final double inPrice;
  final double outPrice;
  final int stockQuantity;

  const Variant({
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
      inPrice: json['inPrice'].toDouble(),
      outPrice: json['outPrice'].toDouble(),
      stockQuantity: json['stockQuantity'],
    );
  }

  @override
  List<Object> get props => [id, weight, inPrice, outPrice, stockQuantity];
}
