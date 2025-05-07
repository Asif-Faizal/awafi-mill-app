import 'dart:math';

import 'package:awafi/features/connection/widgets/connectivity_wrapper.dart';
import 'package:awafi/features/dashboard/presentation/account_screen.dart';
import 'package:awafi/features/dashboard/presentation/colletions_product.dart';
import 'package:awafi/features/dashboard/presentation/search_all_product_screen.dart';
import 'package:awafi/features/dashboard/presentation/sub_category_screen.dart';
import 'package:awafi/features/notification/bloc/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../bloc/banner/banner_images_bloc.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/collection/collections_bloc.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/toggle_wishlist/toggle_wishlist_bloc.dart';
import '../domain/toggle_wishlist/toggle_wishlist_entity.dart';
import 'product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
String? jwtToken;
String? country;

  @override
  void initState() {
    super.initState();
    _loadJwtToken();
  }

  Future<void> _loadJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      jwtToken = prefs.getString('jwtToken');
      country = prefs.getString('country');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      connectedPage: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            style: IconButton.styleFrom(
                backgroundColor: Color(0xFF161A1E),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AccountScreen()));
            },
            icon: Icon(Icons.person, color: Colors.white),
          ),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0.0,
          title: SvgPicture.asset(
            'lib/core/assets/app_name.svg',
            height: 20,
            fit: BoxFit
                .scaleDown, // Ensures proportional scaling within the given size
          ),
          centerTitle: true,
          actions: [
            IconButton(
              style: IconButton.styleFrom(
                  backgroundColor: Color(0xFF161A1E),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchAllProductScreen()),
                );
              },
              icon: Icon(Icons.search, color: Colors.white),
            ),
            SizedBox(width: 10)
          ],
          // bottom: PreferredSize(
          //   preferredSize: Size.fromHeight(80.0),
          //   child: Padding(
          //     padding: const EdgeInsets.all(20),
          //     child: Stack(
          //       children: [
          //         TextField(
          //           readOnly: true,
          //           decoration: InputDecoration(
          //             label: Row(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 Icon(Icons.search, color: Color(0xFF161A1E)),
          //                 SizedBox(width: 10),
          //                 Text('Search..',
          //                     style: TextStyle(
          //                         color: Color(0xFF161A1E), fontSize: 18)),
          //               ],
          //             ),
          //             filled: true,
          //             fillColor: Colors.white,
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(10),
          //               borderSide: BorderSide.none,
          //             ),
          //             enabledBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(20),
          //               borderSide:
          //                   BorderSide(color: Color(0xFF161A1E), width: 0.5),
          //             ),
          //             focusedBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(20),
          //               borderSide:
          //                   BorderSide(color: Color(0xFF161A1E), width: 2),
          //             ),
          //           ),
          //         ),
          //         Positioned.fill(
          //           child: GestureDetector(
          //             onTap: () {
          //               Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) => SearchAllProductScreen()),
          //               );
          //             },
          //             child: Container(color: Colors.transparent),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ),
        body: BlocListener<NotificationBloc, NotificationState>(
          listener: (context, state) {
            debugPrint("NOTIFICATION STATE: $state");
          },
          child: RefreshIndicator(
            onRefresh: () async {
              print('refreshed');
              GetIt.I<BannerBloc>().add(LoadBannersEvent());
              GetIt.I<BannerBloc>().add(LoadCollectionBannersEvent());
              GetIt.I<BannerBloc>().add(LoadOfferBannersEvent());
              GetIt.I<CollectionBloc>().add(FetchCollectionsEvent());
              GetIt.I<ProductBloc>().add(FetchProductsEvent());
              GetIt.I<CategoryBloc>().add(FetchCategoriesEvent());
              return Future.value();
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchAllProductScreen()));
                        },
                        child: BannerCarousals(
                          bloc: GetIt.I<BannerBloc>()..add(LoadBannersEvent()),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          thickness: 0.25,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Top Categories',
                          style: GoogleFonts.mulish(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  sliver: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoading) {
                        return SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.white,
                                margin: EdgeInsets.all(8),
                              ),
                            ),
                            childCount: 6,
                          ),
                        );
                      } else if (state is CategoryLoaded) {
                        return SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final category = state.categories[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SubCategoryScreen(
                                        mainCategoryId: category.id,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 1, color: Colors.black),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Image.network(category.photo,
                                            width: 70,
                                            height: 50,
                                            fit: BoxFit.cover),
                                        SizedBox(height: 5),
                                        Text(
                                          category.name,
                                          style: GoogleFonts.mulish(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          category.description,
                                          style:
                                              GoogleFonts.mulish(fontSize: 10),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: state.categories.length,
                          ),
                        );
                      }
                      return SliverToBoxAdapter(child: Container());
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          thickness: 0.25,
                        ),
                      ),
                      SizedBox(height: 10),
                      BannerCarousals(
                        bloc: GetIt.I<BannerBloc>()
                          ..add(LoadCollectionBannersEvent()),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          thickness: 0.25,
                        ),
                      ),
                      SizedBox(height: 10),
                      BannerCarousals(
                        bloc: GetIt.I<BannerBloc>()
                          ..add(LoadOfferBannersEvent()),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          thickness: 0.25,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Collections',
                          style: GoogleFonts.mulish(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  sliver: BlocBuilder<CollectionBloc, CollectionState>(
                    builder: (context, state) {
                      if (state is CollectionLoading) {
                        return SliverToBoxAdapter(
                            child: Center(child: CircularProgressIndicator()));
                      } else if (state is CollectionLoaded) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final collection = state.collections[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ColletionsProductScreen(colection: state.collections[index].name,collectionId: state.collections[index].id,)));
                                },
                                child: Card(
                                  clipBehavior: Clip
                                      .antiAlias, // Ensures the image doesn't overflow the card
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        12), // Optional: adds rounded corners
                                  ),
                                  child: Stack(
                                    children: [
                                      // Background image
                                      Positioned.fill(
                                        child: Image.network(
                                          collection.photo,
                                          fit: BoxFit
                                              .cover, // Ensures the image fills the card
                                        ),
                                      ),
                                      // Overlay gradient to make text more readable
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.black.withOpacity(0.5),
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.7),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Title and description
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              collection.name,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              collection.description,
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: state.collections.length,
                          ),
                        );
                      } else if (state is CollectionError) {
                        return SliverToBoxAdapter(
                            child: Center(child: Text(state.message)));
                      }
                      return SliverToBoxAdapter(child: Container());
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          thickness: 0.25,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Products',
                          style: GoogleFonts.mulish(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  sliver: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      print("PRODUCT STATE: $state");
                      if (state is ProductLoading) {
                        return SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is ProductLoaded) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index)  {
                              final product = state.products[index];
                              double lowestPriceinAED = product.variants.isNotEmpty
                                  ? product.variants
                                      .map((v) => v.inPrice)
                                      .reduce((a, b) => min(a, b))
                                  : 0;
                              double highestPriceAED = product.variants.isNotEmpty
                                  ? product.variants
                                      .map((v) => v.inPrice)
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailsScreen(
                                          productId: product.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                                          color: Colors
                                                              .grey.shade300,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                    ),
                                                    height: 200,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      child: AspectRatio(
                                                        aspectRatio: 18 / 9,
                                                        child: Image.network(
                                                          product.images
                                                                  .isNotEmpty
                                                              ? product
                                                                  .images[0]
                                                              : '',
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                    ),
                                                  ),jwtToken == null?SizedBox():
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      product.name,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),if(country == 'United Arab Emirates')
                                                    Text(
                                                      'AED  ${lowestPriceinAED.toStringAsFixed(2)} - ${highestPriceAED.toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),if(country != 'United Arab Emirates')
                                                    Text(
                                                      'USD  ${lowestPriceinDollar.toStringAsFixed(2)} - ${highestPriceDollar.toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children:
                                                              List.generate(5,
                                                                  (index) {
                                                            double rating = product
                                                                    .averageRating ??
                                                                0.0; // Default to 0 if null
                                                            if (index <
                                                                rating
                                                                    .floor()) {
                                                              return Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .amber,
                                                                  size: 16);
                                                            } else if (index <
                                                                rating) {
                                                              return Icon(
                                                                  Icons
                                                                      .star_half,
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
                            childCount: state.products.length,
                          ),
                        );
                      } else if (state is ProductError) {
                        return SliverToBoxAdapter(
                          child: Center(child: Text(state.message)),
                        );
                      }
                      return SliverToBoxAdapter(child: Container());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BannerCarousals extends StatelessWidget {
  final BannerBloc bloc;
  const BannerCarousals({
    super.key,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = screenWidth * 0.8; // 80% of screen width
    final imageHeight = imageWidth / 2; // height is half of width for 2:1 ratio

    return BlocBuilder<BannerBloc, BannerState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is BannerLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: SizedBox(
                width: imageWidth,
                height: imageHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          );
        } else if (state is BannerLoaded) {
          if (state.banners.isEmpty) {
            return CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                height: imageHeight,
              ),
              items: List.generate(3, (index) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: imageWidth,
                      height: imageHeight,
                      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/core/assets/app_name.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                  height: imageHeight,
                ),
                items: state.banners.map((banner) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: imageWidth,
                        height: imageHeight,
                        margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                banner.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'lib/core/assets/placeholder.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                              // Positioned(
                              //   bottom: 10,
                              //   left: 10,
                              //   child: Text(
                              //     banner.name,
                              //     style: TextStyle(
                              //       color: Colors.white,
                              //       fontSize: 16,
                              //       fontWeight: FontWeight.bold,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            );
          }
        } else if (state is BannerError) {
          return CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.8,
              height: imageHeight,
            ),
            items: List.generate(3, (index) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: imageWidth,
                    height: imageHeight,
                    margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'lib/core/assets/app_name.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }),
          );
        } else {
          return CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.8,
              height: imageHeight,
            ),
            items: List.generate(3, (index) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: imageWidth,
                    height: imageHeight,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'lib/core/assets/app_name.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }),
          );
        }
      },
    );
  }
}
