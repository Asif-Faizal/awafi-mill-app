import 'package:awafi/features/connection/widgets/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../login/presentation/login_screen.dart';
import '../bloc/addCart/add_cart_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/product_details/product_details_bloc.dart';
import '../bloc/toggle_wishlist/toggle_wishlist_bloc.dart';
import '../bloc/wishlist/wishlist_bloc.dart';
import '../domain/addCart/add_cart_entity.dart';
import '../domain/product_details/product_details_entity.dart';
import '../domain/toggle_wishlist/toggle_wishlist_entity.dart';
import '../widgets/bottom_nav_bar.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId});
  final String productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  int selectedVariantIndex = 0;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String? jwtToken;

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      jwtToken = prefs.getString('jwtToken');
    });
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
    context
        .read<ProductIndividualBloc>()
        .add(GetProductIndividualEvent(widget.productId));
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (_currentPage != page) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      connectedPage: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
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
                Icons.shopping_bag,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ProductIndividualBloc>().add(
                  GetProductIndividualEvent(widget.productId),
                );
          },
          child: BlocListener<AddCartBloc, AddCartState>(
            listener: (context, state) async {
              if (state is CartFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    content: Text(state.error)));
              } else if (state is CartSuccess) {
                // await Future.delayed(Duration(seconds: 1));
                context
                    .read<ProductIndividualBloc>()
                    .add(GetProductIndividualEvent(widget.productId));
              }
            },
            child: BlocListener<ToggleWishlistBloc, ToggleWishlistState>(
              listener: (context, state) {
                if (state is WishlistError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      content: Text(state.message)));
                }
              },
              child: BlocBuilder<ProductIndividualBloc, ProductIndividualState>(
                builder: (context, state) {
                  if (state is ProductIndividualLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductIndividualLoaded) {
                    return _buildProductDetails(state.productDetails);
                  } else if (state is ProductIndividualError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: BlocBuilder<AddCartBloc, AddCartState>(
            builder: (context, cartState) {
              if (cartState is AddCartLoading) {
                return _buildLoadingButton();
              }

              return BlocBuilder<ProductIndividualBloc, ProductIndividualState>(
                builder: (context, productState) {
                  print("PRODUCT STATE: $productState");
                  if (productState is ProductIndividualLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (productState is ProductIndividualLoaded) {
                    return _buildActionButton(context, productState);
                  }
                  return const SizedBox.shrink();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingButton() {
    return ElevatedButton(
      style: _buttonStyle(),
      onPressed: () {},
      child: const SizedBox(
        height: 35,
        width: 35,
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, ProductIndividualLoaded state) {
    final bool isInCart = state.productDetails.inCart ?? false;

    return ElevatedButton(
      style: _buttonStyle(),
      onPressed: () => _handleButtonPress(context, isInCart, state),
      child: Text(
        _getButtonText(isInCart),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFF414851),
    );
  }

  String _getButtonText(bool isInCart) {
    if (jwtToken == null) return 'LOGIN TO CONTINUE';
    return isInCart ? 'VIEW CART' : 'ADD TO CART';
  }

  void _handleButtonPress(
    BuildContext context,
    bool isInCart,
    ProductIndividualLoaded state,
  ) async {
    if (jwtToken == null) {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

      // Reload token after returning from login screen
      if (result == true) {
        await _loadToken();
      }
      return;
    }

    if (isInCart) {
      context.read<CartBloc>().add(FetchCartItems());
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const BottomScreen(initialIndex: 1),
        ),
      );
      return;
    }

    final cartItem = AddCartItem(
      productId: state.productDetails.id,
      variantId: state.productDetails.variants[selectedVariantIndex].id,
      quantity: quantity,
    );

    context.read<AddCartBloc>().add(AddCartItemEvent(cartItem: cartItem));

    // Safe delayed operation with mounted check
    if (mounted) {
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          context
              .read<ProductIndividualBloc>()
              .add(GetProductIndividualEvent(widget.productId));
        }
      });
    }
  }

  Widget _buildProductDetails(ProductIndividualEntity product) {
    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<ProductIndividualBloc>()
            .add(GetProductIndividualEvent(widget.productId));
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Stack(
              children: [
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: product.images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.network(
                          product.images[index],
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fitHeight,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(product.images.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        height: index == _currentPage ? 13 : 10,
                        width: index == _currentPage ? 13 : 10,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: index == _currentPage
                                    ? Color(0xFF414851)
                                    : Color(0xFF414851),
                                width: 2),
                            shape: BoxShape.circle,
                            color: index == _currentPage
                                ? Colors.white
                                : Color(0xFF414851)),
                      );
                    }),
                  ),
                ),
                if (jwtToken != null)
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: BlocBuilder<ToggleWishlistBloc, ToggleWishlistState>(
                      builder: (context, state) {
                        // Show loading indicator while wishlist is being updated
                        if (state is WishlistItemLoading) {
                          return const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          );
                        }

                        return IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF161A1E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            final wishlistItem = ToggleWishlistItem(
                              productId: product.id,
                              variantId:
                                  product.variants[selectedVariantIndex].id,
                            );

                            // Toggle wishlist action based on current status
                            if (product.inWishlist == true) {
                              // Remove from wishlist
                              context.read<ToggleWishlistBloc>().add(
                                    RemoveItemFromWishlistEvent(wishlistItem),
                                  );
                            } else {
                              // Add to wishlist
                              context.read<ToggleWishlistBloc>().add(
                                    AddItemToWishlistEvent(wishlistItem),
                                  );
                            }

                            // Delay and update product and wishlist states
                            await Future.delayed(const Duration(seconds: 1));
                            context.read<ProductIndividualBloc>().add(
                                  GetProductIndividualEvent(widget.productId),
                                );
                            context.read<WishlistBloc>().add(
                                  LoadWishlistItems(),
                                );
                          },
                          icon: Icon(
                            product.inWishlist == true
                                ? Icons.favorite
                                : Icons.favorite_outline_outlined,
                            color: product.inWishlist == true
                                ? Colors.red
                                : Colors.white,
                          ),
                        );
                      },
                    ),
                  )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: GoogleFonts.mulish(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(product.ean,
                                style:
                                    GoogleFonts.mulish(color: Colors.black87)),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Stars based on averageRating
                                Row(
                                                        children: List.generate(
                                                            5, (index) {
                                                          double rating = product
                                                                  .averageRating ??
                                                              0.0; // Default to 0 if null
                                                          if (index <
                                                              rating.floor()) {
                                                            return Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                                size: 16);
                                                          } else if (index <
                                                              rating) {
                                                            return Icon(
                                                                Icons.star_half,
                                                                color: Colors
                                                                    .amber,
                                                                size: 16);
                                                          } else {
                                                            return Icon(
                                                                Icons
                                                                    .star_border,
                                                                color: Colors
                                                                    .amber,
                                                                size: 16);
                                                          }
                                                        }),
                                                      ),
                                SizedBox(width: 8),
                                Text(
                                  'Total reviews ${product.totalReviews.toString()}',
                                  style: GoogleFonts.mulish(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 130,
                        child: Card(
                          elevation: 2,
                          color: const Color(0xFF161A1E),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (quantity > 1) quantity--;
                                  });
                                },
                                icon: const Icon(Icons.remove,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                width: 20,
                                child: Center(
                                  child: Text(
                                    '$quantity',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (quantity <
                                        product.variants[selectedVariantIndex]
                                            .stockQuantity) {
                                      quantity++;
                                    }
                                  });
                                },
                                icon:
                                    const Icon(Icons.add, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${product.variants[selectedVariantIndex].stockQuantity} in stock',
                    style: TextStyle(
                        fontSize: 16,
                        color: product.variants[selectedVariantIndex]
                                    .stockQuantity <
                                15
                            ? Colors.redAccent
                            : Colors.green),
                  ),
                  Text(
                    '\$${product.variants[selectedVariantIndex].inPrice * quantity}',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Variants:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  // ListView of toggle buttons for variants
                  SizedBox(
                    height: 30, // Set height to fit the buttons
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: product.variants.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedVariantIndex == index
                                  ? const Color(0xFF161A1E)
                                  : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedVariantIndex = index;
                                quantity =
                                    1; // Reset quantity to 1 when variant changes
                              });
                            },
                            child: Text(
                              product.variants[index].weight,
                              style: TextStyle(
                                color: selectedVariantIndex == index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Descriptions:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  ...product.descriptions.map((desc) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(desc.header,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(desc.content),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
