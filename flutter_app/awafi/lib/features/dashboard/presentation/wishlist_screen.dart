import 'package:awafi/features/connection/widgets/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../login/presentation/login_screen.dart';
import '../bloc/toggle_wishlist/toggle_wishlist_bloc.dart';
import '../bloc/wishlist/wishlist_bloc.dart';
import '../domain/toggle_wishlist/toggle_wishlist_entity.dart';
import '../domain/wishlist/wishlist_entity.dart';
import 'product_details_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistBloc>().add(LoadWishlistItems());
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      connectedPage: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Wishlist',
            style:
                GoogleFonts.mulish(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<WishlistBloc, WishlistState>(
          builder: (context, state) {
            print(state);
            if (state is WishlistLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is WishlistLoaded) {
              if (state.wishlistItems.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 120),
                          child: Image.asset('lib/core/assets/no-wishlist.png'),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Add items to your wishlist',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: state.wishlistItems.length,
                  itemBuilder: (context, index) {
                    final item = state.wishlistItems[index];
                    return WishlistItemTile(item: item);
                  },
                );
              }
            } else if (state is UserNotLoggedIn) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Image.asset('lib/core/assets/error.png'),
                      ),
                      SizedBox(height: 50),
                      Text(
                        'You are not logged in. Please log in to continue.',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFF414851),
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              (r) => false,
                            );
                          },
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Center(child: Text('No Wishlist Data'));
          },
        ),
      ),
    );
  }
}

class WishlistItemTile extends StatelessWidget {
  final WishlistItemEntity item;

  const WishlistItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    bool isAvailable = item.stockQuantity > 0;
    return InkWell(
      onTap: () {
        print(item.productId);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                      productId: item.productId,
                    )));
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                        height: 200,
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                          child: AspectRatio(
                            aspectRatio: 18 / 9,
                            child: Image.network(
                              item.images,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),Positioned(
                                                top: 0,
                                                left: 0,
                                                child: Stack(
                                                  children: [
                                                    // Fading black background
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade300,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        7)),
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 5),
                                                      child: Text(
                                                        isAvailable
                                                            ? 'In Stock'
                                                            : 'Out of Stock',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: isAvailable
                                                              ? Colors.green
                                                              : Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                    // Text on top of the fading background
                                                  ],
                                                ),
                                              ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 5,),
                        Text(
                          item.name,
                          style: GoogleFonts.mulish(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'AED ${item.inPrice.toStringAsFixed(2)} - ${item.outPrice.toStringAsFixed(2)}',
                          style: GoogleFonts.mulish(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            double rating =
                                item.rating ?? 0.0; // Default to 0 if null
                            if (index < rating.floor()) {
                              return Icon(Icons.star,
                                  color: Colors.amber, size: 16);
                            } else if (index < rating) {
                              return Icon(Icons.star_half,
                                  color: Colors.amber, size: 16);
                            } else {
                              return Icon(Icons.star_border,
                                  color: Colors.amber, size: 16);
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 22,
            right: 30,
            child: IconButton(
              iconSize: 1,
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF161A1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                final wishlistItem = ToggleWishlistItem(
                    productId: item.productId, variantId: item.variantId);
                context
                    .read<ToggleWishlistBloc>()
                    .add(RemoveItemFromWishlistEvent(wishlistItem));
                await Future.delayed(Duration(seconds: 3));
                context.read<WishlistBloc>().add(LoadWishlistItems());
              },
              icon: const Icon(
                Icons.close,
                size: 20,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
