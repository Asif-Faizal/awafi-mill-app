import 'package:awafi/features/connection/widgets/connectivity_wrapper.dart';
import 'package:awafi/features/dashboard/bloc/sub_category_product/sub_category_product_bloc.dart';
import 'package:awafi/features/dashboard/presentation/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../bloc/subCategory/sub_category_bloc.dart';
import '../data/sub_category_product/sub_category_product_model.dart';

class SubCategoryScreen extends StatefulWidget {
  final String mainCategoryId;

  const SubCategoryScreen({super.key, required this.mainCategoryId});

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  late SubCategoryBloc _subCategoryBloc;
  late SubCategoryProductBloc _subCategoryProductBloc;
  String? _selectedSubCategoryId;

  @override
  void initState() {
    super.initState();
    _subCategoryBloc = BlocProvider.of<SubCategoryBloc>(context);
    _subCategoryProductBloc = BlocProvider.of<SubCategoryProductBloc>(context);
    _subCategoryBloc
        .add(FetchSubCategories(mainCategoryId: widget.mainCategoryId));
    _subCategoryBloc.stream.listen((state) {
      if (state is SubCategoryLoaded && state.subCategories.isNotEmpty) {
        final firstSubCategory = state.subCategories.first;
        setState(() {
          _selectedSubCategoryId = firstSubCategory.id;
        });
        _subCategoryProductBloc.add(
          FetchSubCategoryProductEvent(subCategoryId: firstSubCategory.id),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      connectedPage: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF161A1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
        ),
        body: BlocBuilder<SubCategoryBloc, SubCategoryState>(
          builder: (context, state) {
            print("SUB CATEGORY STATE: $state");
            if (state is SubCategoryLoading) {
              return _buildShimmerLoading();
            } else if (state is SubCategoryLoaded) {
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                itemCount: state.subCategories.length,
                itemBuilder: (context, index) {
                  final subCategory = state.subCategories[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Colors.grey.shade400,
                        child: ListTile(
                          trailing: Icon(
                            _selectedSubCategoryId == subCategory.id
                                ? Icons
                                    .keyboard_arrow_down_rounded // Downward arrow
                                : Icons
                                    .arrow_forward_ios_rounded, // Forward arrow
                          ),
                          title: Text(subCategory.name),
                          subtitle: Text(subCategory.description),
                          onTap: () {
                            setState(() {
                              _selectedSubCategoryId = subCategory.id;
                            });
                            _subCategoryProductBloc.add(
                              FetchSubCategoryProductEvent(
                                subCategoryId: subCategory.id,
                              ),
                            );
                          },
                        ),
                      ),
                      if (_selectedSubCategoryId == subCategory.id) ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 200,
                          child: BlocBuilder<SubCategoryProductBloc,
                              SubCategoryProductState>(
                            builder: (context, productState) {
                              if (productState is ProductLoading) {
                                return _buildProductShimmer();
                              } else if (productState is ProductLoaded) {
                                if (productState.products.isEmpty) {
                                  return const Center(
                                    child: Text('No products available'),
                                  );
                                }
                                return ListView.builder(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: productState.products.length,
                                  itemBuilder: (context, productIndex) {
                                    final product =
                                        productState.products[productIndex];
                                    // Get the first variant or set default values
                                    final variant = product.variants.isNotEmpty
                                        ? product.variants.first
                                        : Variant(
                                            id: '',
                                            weight: '',
                                            inPrice: 0,
                                            outPrice: 0,
                                            stockQuantity: 0);
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetailsScreen(
                                                        productId:
                                                            product.id)));
                                      },
                                      child: Card(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: Container(
                                          width: 150,
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        product.images
                                                                .isNotEmpty
                                                            ? product
                                                                .images.first
                                                            : 'https://placeholder.com/150',
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                product.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '\$${variant.outPrice.toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    variant.weight,
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else if (productState is ProductError) {
                                return Center(
                                  child: Text(
                                    'Error: ${productState.message}',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ],
                  );
                },
              );
            } else if (state is SubCategoryError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const Center(child: Text('No subcategories available.'));
          },
        ),
      ),
    );
  }

  Widget _buildProductShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: const EdgeInsets.only(right: 10),
            child: Container(
              width: 150,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image placeholder
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Title placeholder (two lines)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 100,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Price and weight row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 60,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card shimmer for subcategory
                  Card(
                    child: Container(
                      height: 72, // Standard ListTile height
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          // Title and subtitle area
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 140,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 200,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Trailing icon shimmer
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Product list shimmer (shown only for first item to simulate selected state)
                  if (index == 0) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: _buildProductShimmer(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
