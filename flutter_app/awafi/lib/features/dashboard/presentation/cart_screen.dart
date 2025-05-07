import 'package:awafi/features/connection/widgets/connectivity_wrapper.dart';
import 'package:awafi/features/dashboard/presentation/checkout_screen.dart';
import 'package:awafi/features/dashboard/presentation/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package

import '../../login/presentation/login_screen.dart';
import '../bloc/address/address_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../data/cart/cart_datasource.dart';
import '../data/cart/cart_repo_impl.dart';
import '../domain/cart/cart_entity.dart';
import '../domain/cart/get_cart_items.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartBloc(
        GetCartItems(CartRepositoryImpl(
            CartDataSourceImpl())), // Inject your GetCartItems use case
        CartRepositoryImpl(CartDataSourceImpl()),
      )..add(FetchCartItems()),
      child: ConnectivityWrapper(
        connectedPage: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              'Cart',
              style:
                  GoogleFonts.mulish(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          body: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              print(state);
              if (state is CartLoading) {
                // Shimmer Effect for Loading State
                return ListView.builder(
                  itemCount:
                      5, // Set a placeholder item count for shimmer effect
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CartItemShimmerWidget(),
                    );
                  },
                );
              } else if (state is CartLoaded ||
                  state is CartUpdated ||
                  state is CartRemoved) {
                if (state is CartLoaded && state.items.isEmpty ||
                    state is CartUpdated && state.updatedItems.isEmpty ||
                    state is CartRemoved && state.updatedItems.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 120),
                            child: Image.asset(
                              'lib/core/assets/cart.png',
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            'Add items to your cart',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: state is CartLoaded
                      ? state.items.length
                      : state is CartUpdated
                          ? state.updatedItems.length
                          : state is CartRemoved
                              ? state.updatedItems.length
                              : 0,
                  itemBuilder: (context, index) {
                    final item = state is CartLoaded
                        ? state.items[index]
                        : state is CartUpdated
                            ? state.updatedItems[index]
                            : state is CartRemoved
                                ? state.updatedItems[index]
                                : null;
                    return CartItemWidget(
                        item: item!); // Ensure `item` is non-null
                  },
                );
              } else if (state is CartError) {
                return Center(child: Text(state.message));
              } else if (state is CartNotFound) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 120),
                          child: Image.asset(
                            'lib/core/assets/cart.png',
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Add items to your cart',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is CartUnauthorized) {
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
              } else {
                return Center(child: Text('No Cart Items'));
              }
            },
          ),
          bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              double totalAmount = 0.0;

              // Check if the state is CartLoaded, CartUpdated, or CartRemoved and calculate the total amount
              if (state is CartLoaded) {
                totalAmount = state.items.fold(0.0, (sum, item) {
                  return sum + (item.outPrice * item.quantity);
                });
              } else if (state is CartUpdated) {
                totalAmount = state.updatedItems.fold(0.0, (sum, item) {
                  return sum + (item.outPrice * item.quantity);
                });
              } else if (state is CartRemoved) {
                totalAmount = state.updatedItems.fold(0.0, (sum, item) {
                  return sum + (item.outPrice * item.quantity);
                });
              }

              // If state is CartUnauthorized, return an empty bottomAppBar (no UI shown)
              if (state is CartUnauthorized) {
                return SizedBox(); // This hides the BottomAppBar
              }

              return BottomAppBar(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: AED ${totalAmount.toStringAsFixed(2)}',
                      style: GoogleFonts.mulish(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF414851),
                        ),
                        onPressed: totalAmount > 0
                            ? () async {
                                List<Map<String, dynamic>> cartItemsData =
                                    state is CartLoaded
                                        ? (state.items).map((item) {
                                            return {
                                              "product": item.productId,
                                              "variant": item.variantId,
                                              "quantity": item.quantity,
                                            };
                                          }).toList()
                                        : [];
                                context
                                    .read<GetAddressBloc>()
                                    .add(FetchAddress());
                                await Future.delayed(Duration(seconds: 1));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckoutScreen(
                                          amount: totalAmount,
                                          cartItems: cartItemsData)),
                                );
                                print('Proceed to checkout');
                              }
                            : null,
                        child: Text(
                          'CHECKOUT',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CartItemShimmerWidget extends StatelessWidget {
  const CartItemShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          color: Colors.white,
        ),
        title: Container(
          width: 150,
          height: 15,
          color: Colors.white,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 10,
              color: Colors.white,
            ),
            SizedBox(height: 5),
            Container(
              width: 50,
              height: 10,
              color: Colors.white,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Container(
              width: 30,
              height: 30,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Container(
              width: 30,
              height: 30,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    bool isAvailable = item.quantity > 0;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductDetailsScreen(productId: item.productId)));
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
                      Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        height: 200,
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                          child: Image.network(
                            item.images, // Assuming images is a string URL
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Stack(
                          children: [
                            // Fading black background
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(7)),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              child: Text(
                                isAvailable ? 'In Stock' : 'Out of Stock',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isAvailable ? Colors.green : Colors.red,
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
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'AED ${item.outPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item.outPrice} * ${item.quantity} = AED ${item.outPrice * item.quantity}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              Card(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        if (item.quantity > 1) {
                                          context
                                              .read<CartBloc>()
                                              .add(UpdateCartQuantity(
                                                productId: item.productId,
                                                variantId: item.variantId,
                                                quantity: item.quantity - 1,
                                              ));
                                        }
                                      },
                                    ),
                                    Text(item.quantity.toString()),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        context
                                            .read<CartBloc>()
                                            .add(UpdateCartQuantity(
                                              productId: item.productId,
                                              variantId: item.variantId,
                                              quantity: item.quantity + 1,
                                            ));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
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
                // Remove item from cart functionality
                context.read<CartBloc>().add(RemoveCartItem(
                      productId: item.productId,
                      variantId: item.variantId,
                    ));
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
