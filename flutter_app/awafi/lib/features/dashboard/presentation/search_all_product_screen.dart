import 'package:awafi/features/connection/widgets/connectivity_wrapper.dart';
import 'package:awafi/features/dashboard/presentation/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import '../bloc/product/product_bloc.dart';
import '../bloc/toggle_wishlist/toggle_wishlist_bloc.dart';
import '../domain/toggle_wishlist/toggle_wishlist_entity.dart';

class SearchAllProductScreen extends StatefulWidget {
  const SearchAllProductScreen({super.key});

  @override
  State<SearchAllProductScreen> createState() => _SearchAllProductScreenState();
}

class _SearchAllProductScreenState extends State<SearchAllProductScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  String _searchText = '';

String? jwtToken;

  @override
  void initState() {
    super.initState();
    _loadJwtToken();
  }

  Future<void> _loadJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      jwtToken = prefs.getString('jwtToken');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Request focus on the text field when the dependencies change
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<ProductBloc>()..add(FetchProductsEvent()),
      child: ConnectivityWrapper(
        connectedPage: Scaffold(
          backgroundColor: Colors.white,
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
            actions: [
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF161A1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(
                  Icons.filter_alt_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  focusNode: _focusNode,
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search,
                          color: Color(0xFF161A1E),
                        ),
                        SizedBox(width: 10),
                        Text('Search..',
                            style: TextStyle(
                                color: Color(0xFF161A1E), fontSize: 18)),
                      ],
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Color(0xFF161A1E), width: 0.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Color(0xFF161A1E), width: 2),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProductLoaded) {
                      final filteredProducts = state.products
                          .where((product) => product.name
                              .toLowerCase()
                              .contains(_searchText.toLowerCase()))
                          .toList();

                      return ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];

                          // Calculate the lowest and highest prices from the variants
                          double lowestPrice = product.variants.isNotEmpty
                              ? product.variants
                                  .map((v) => v.inPrice)
                                  .reduce((a, b) => min(a, b))
                              : 0;
                          double highestPrice = product.variants.isNotEmpty
                              ? product.variants
                                  .map((v) => v.outPrice)
                                  .reduce((a, b) => max(a, b))
                              : 0;
                          double lowestPriceinDollar =
                                  product.variants.isNotEmpty
                                      ? product.variants
                                          .map((v) => v.outPrice)
                                          .reduce((a, b) => min(a, b))
                                      : 0;
                          double highestPriceDollar =
                                  product.variants.isNotEmpty
                                      ? product.variants
                                          .map((v) => v.outPrice)
                                          .reduce((a, b) => max(a, b))
                                      : 0;
                          bool isAvailable = product.variants
                              .any((variant) => variant.stockQuantity > 0);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailsScreen(
                                      productId: product.id,
                                    ),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                                height: 200,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: AspectRatio(
                                                    aspectRatio: 18 / 9,
                                                    child: Image.network(
                                                      product.images.isNotEmpty
                                                          ? product.images[0]
                                                          : '',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                                  jwtToken == null?SizedBox():
                                                  BlocBuilder<
                                                      ToggleWishlistBloc,
                                                      ToggleWishlistState>(
                                                    builder: (context, state) {
                                                      bool isInWishlist =
                                                          product.inWishlist;

                                                      // Update `isInWishlist` based on the Bloc state
                                                      if (state
                                                              is WishlistItemAdded &&
                                                          state.item
                                                                  .productId ==
                                                              product.id) {
                                                        isInWishlist = true;
                                                      } else if (state
                                                              is WishlistItemRemoved &&
                                                          state.item
                                                                  .productId ==
                                                              product.id) {
                                                        isInWishlist = false;
                                                      }

                                                      return Positioned(
                                                        bottom: 0,
                                                        right: 0,
                                                        child: IconButton(
                                                          style: IconButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Color(
                                                                    0xFF161A1E),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            final wishlistItem =
                                                                ToggleWishlistItem(
                                                              productId:
                                                                  product.id,
                                                              variantId: product
                                                                  .variants
                                                                  .first
                                                                  .id,
                                                            );

                                                            if (isInWishlist) {
                                                              // Remove from wishlist
                                                              context
                                                                  .read<
                                                                      ToggleWishlistBloc>()
                                                                  .add(
                                                                    RemoveItemFromWishlistEvent(
                                                                        wishlistItem),
                                                                  );
                                                            } else {
                                                              // Add to wishlist
                                                              context
                                                                  .read<
                                                                      ToggleWishlistBloc>()
                                                                  .add(
                                                                    AddItemToWishlistEvent(
                                                                        wishlistItem),
                                                                  );
                                                            }
                                                          },
                                                          icon: isInWishlist
                                                              ? Icon(
                                                                  Icons
                                                                      .favorite,
                                                                  color: Colors
                                                                      .red,
                                                                )
                                                              : Icon(
                                                                  Icons
                                                                      .favorite_border,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  product.name,
                                                  style: GoogleFonts.mulish(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  'AED  ${lowestPrice.toStringAsFixed(2)} - ${highestPrice.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: List.generate(5,
                                                          (index) {
                                                        double rating = product
                                                                .averageRating ??
                                                            0.0; // Default to 0 if null
                                                        if (index <
                                                            rating.floor()) {
                                                          return Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                              size: 16);
                                                        } else if (index <
                                                            rating) {
                                                          return Icon(
                                                              Icons.star_half,
                                                              color:
                                                                  Colors.amber,
                                                              size: 16);
                                                        } else {
                                                          return Icon(
                                                              Icons.star_border,
                                                              color:
                                                                  Colors.amber,
                                                              size: 16);
                                                        }
                                                      }),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '${product.totalReviews.toString()} reviews',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is ProductError) {
                      return Center(child: Text(state.message));
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
