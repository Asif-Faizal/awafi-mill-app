import 'package:equatable/equatable.dart';

class CollectionProductEntity extends Equatable {
  final String id;
  final String sku;
  final String name;
  final List<DescriptionEntity> descriptions;
  final bool isListed;
  final bool isDelete;
  final List<String> images;
  final List<VariantEntity> variants;
  final double averageRating;
  final int totalReviews;

  const CollectionProductEntity({
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

  @override
  List<Object?> get props => [id, sku, name, averageRating, totalReviews];
}

class DescriptionEntity extends Equatable {
  final String header;
  final String content;

  const DescriptionEntity({required this.header, required this.content});

  @override
  List<Object?> get props => [header, content];
}

class VariantEntity extends Equatable {
  final String weight;
  final double inPrice;
  final double outPrice;
  final int stockQuantity;

  const VariantEntity({
    required this.weight,
    required this.inPrice,
    required this.outPrice,
    required this.stockQuantity,
  });

  @override
  List<Object?> get props => [weight, inPrice, outPrice, stockQuantity];
}
