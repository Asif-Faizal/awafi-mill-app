import 'package:equatable/equatable.dart';

class SubCategoryProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final List<Variant> variants;

  const SubCategoryProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.variants,
  });

  @override
  List<Object> get props => [id, name, description, images, variants];
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

  @override
  List<Object> get props => [id, weight, inPrice, outPrice, stockQuantity];
}
