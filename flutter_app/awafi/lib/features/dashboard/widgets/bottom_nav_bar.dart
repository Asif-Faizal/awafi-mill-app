import 'package:awafi/features/dashboard/bloc/wishlist/wishlist_bloc.dart';
import 'package:awafi/features/dashboard/presentation/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/injection/injection.dart';
import '../bloc/bottom_nav_bar/bottom_navigation_bar_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/userData/user_data_bloc.dart';
import '../presentation/cart_screen.dart';
import '../presentation/home_screen.dart';
import '../presentation/wishlist_screen.dart';
import 'bottom_bar_items.dart';

class BottomScreen extends StatelessWidget {
  final int initialIndex;

  const BottomScreen({super.key, this.initialIndex = 0}); // Default to Home tab if no index is provided

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BottomNavigationBloc>()..add(ChangeTab(initialIndex)),
      child: Scaffold(backgroundColor: Colors.white,
        body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
            return IndexedStack(
              index: state.selectedIndex,
              children: [
                HomeScreen(),
                CartScreen(),
                WishlistScreen(),
                NotificationsScreen(),
              ],
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
            return Card(
              color:Colors.white,
              elevation: 0,
              child: SizedBox(
                height: 70,
                width: double.infinity,
                child: Row(
                  children: [
                    CustomBottomWidget(
                      index: 0,
                      text: 'Home',
                      image: 'lib/core/assets/home.png',
                      currentIndex: state.selectedIndex,
                      onTap: () {
                        context.read<BottomNavigationBloc>().add(ChangeTab(0));
                      },
                    ),
                    CustomBottomWidget(
                      index: 1,
                      text: 'Cart',
                      image: 'lib/core/assets/cart.png',
                      currentIndex: state.selectedIndex,
                      onTap: () {
                        context.read<CartBloc>().add(FetchCartItems());
                        context.read<BottomNavigationBloc>().add(ChangeTab(1));
                      },
                    ),
                    CustomBottomWidget(
                      index: 2,
                      text: 'Wish-list',
                      image: 'lib/core/assets/wishlist.png',
                      currentIndex: state.selectedIndex,
                      onTap: () {
                        context.read<WishlistBloc>().add(LoadWishlistItems());
                        context.read<BottomNavigationBloc>().add(ChangeTab(2));
                      },
                    ),
                    CustomBottomWidget(
                      index: 3,
                      text: 'Notifications',
                      image: 'lib/core/assets/person.png',
                      currentIndex: state.selectedIndex,
                      onTap: () {
                        context.read<BottomNavigationBloc>().add(ChangeTab(3));
                        context.read<UserProfileBloc>().add(FetchUserProfile());
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

