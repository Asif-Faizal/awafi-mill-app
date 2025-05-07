import 'package:awafi/core/config/api_config.dart';
import 'package:awafi/features/connection/bloc/connectivity_bloc.dart';
import 'package:awafi/features/dashboard/bloc/addAddress/add_address_bloc.dart';
import 'package:awafi/features/dashboard/bloc/addCart/add_cart_bloc.dart';
import 'package:awafi/features/dashboard/bloc/address/address_bloc.dart';
import 'package:awafi/features/dashboard/bloc/bottom_nav_bar/bottom_navigation_bar_bloc.dart';
import 'package:awafi/features/dashboard/bloc/checkout/checkout_bloc.dart';
import 'package:awafi/features/dashboard/bloc/collection/collections_bloc.dart';
import 'package:awafi/features/dashboard/bloc/collectionProducts/collection_products_bloc.dart';
import 'package:awafi/features/dashboard/bloc/product/product_bloc.dart';
import 'package:awafi/features/dashboard/bloc/product_details/product_details_bloc.dart';
import 'package:awafi/features/dashboard/bloc/subCategory/sub_category_bloc.dart';
import 'package:awafi/features/dashboard/bloc/toggle_wishlist/toggle_wishlist_bloc.dart';
import 'package:awafi/features/dashboard/bloc/wishlist/wishlist_bloc.dart';
import 'package:awafi/features/login/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:awafi/features/login/bloc/login/login_bloc.dart';
import 'package:awafi/features/notification/bloc/notification_bloc.dart';
import 'package:awafi/features/orders/bloc/cancel_order/cancel_order_bloc.dart';
import 'package:awafi/features/orders/bloc/order/orders_bloc.dart';
import 'package:awafi/features/signup/bloc/register/register_bloc.dart';
import 'package:awafi/features/signup/bloc/signup_input/signup_input_bloc.dart';
import 'package:awafi/features/splash/presentation/splash_screen.dart';
import 'package:awafi/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'core/injection/injection.dart';
import 'features/dashboard/bloc/banner/banner_images_bloc.dart';
import 'features/dashboard/bloc/cart/cart_bloc.dart';
import 'features/dashboard/bloc/category/category_bloc.dart';
import 'features/dashboard/bloc/payment_intent/payment_intent_bloc.dart';
import 'features/dashboard/bloc/sub_category_product/sub_category_product_bloc.dart';
import 'features/dashboard/bloc/userData/user_data_bloc.dart';
import 'features/login/bloc/login_input/login_input_bloc.dart';
import 'features/orders/bloc/return_order/return_order_bloc.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Stripe.publishableKey = ApiConfig.stripePublishableKey;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginInputBloc>(
          create: (context) => GetIt.I<LoginInputBloc>(),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => GetIt.I<LoginBloc>(),
        ),
        BlocProvider<CountryCodeBloc>(
          create: (context) => GetIt.I<CountryCodeBloc>(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => GetIt.I<UserBloc>(),
        ),
        BlocProvider(create: (_) => GetIt.I<BannerBloc>()..add(LoadBannersEvent())),
        BlocProvider(create: (_) => GetIt.I<BannerBloc>()..add(LoadOfferBannersEvent())),
        BlocProvider(create: (_) => GetIt.I<BannerBloc>()..add(LoadCollectionBannersEvent())),
        BlocProvider(create: (_) => GetIt.I<CategoryBloc>()..add(FetchCategoriesEvent())),
        BlocProvider<ForgotPasswordBloc>(
          create: (context) => GetIt.I<ForgotPasswordBloc>(),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => GetIt.I<ProductBloc>()..add(FetchProductsEvent()),
        ),
        BlocProvider<UserProfileBloc>(
          create: (context) => GetIt.I<UserProfileBloc>()..add(FetchUserProfile()),
        ),
        BlocProvider<GetAddressBloc>(
          create: (context) => GetIt.I<GetAddressBloc>()..add(FetchAddress()),
        ),
        BlocProvider<BottomNavigationBloc>(
          create: (context) => GetIt.I<BottomNavigationBloc>(),
        ),
        BlocProvider<SubCategoryBloc>(
          create: (context) => GetIt.I<SubCategoryBloc>(),
        ),
        BlocProvider<ProductIndividualBloc>(
          create: (context) => GetIt.I<ProductIndividualBloc>(),
        ),
        BlocProvider<ToggleWishlistBloc>(
          create: (context) => GetIt.I<ToggleWishlistBloc>(),
        ),
        BlocProvider<WishlistBloc>(
          create: (context) => GetIt.I<WishlistBloc>(),
        ),
        BlocProvider<AddCartBloc>(
          create: (context) => GetIt.I<AddCartBloc>(),
        ),
        BlocProvider<CartBloc>(
          create: (context) => GetIt.I<CartBloc>()..add(FetchCartItems()),
        ),
        BlocProvider<AddAddressBloc>(
          create: (context) => GetIt.I<AddAddressBloc>(),
        ),
        BlocProvider<CheckoutBloc>(
          create: (context) => GetIt.I<CheckoutBloc>(),
        ),
        BlocProvider<SubCategoryProductBloc>(
          create: (context) => GetIt.I<SubCategoryProductBloc>(),
        ),
        BlocProvider<OrdersBloc>(
          create: (context) => GetIt.I<OrdersBloc>()..add(LoadOrders(page: 1, limit: 10)),
        ),
        BlocProvider<ConnectivityBloc>(
          create: (context) => GetIt.I<ConnectivityBloc>()),
        BlocProvider<NotificationBloc>(
          create: (context) => GetIt.I<NotificationBloc>()),
        BlocProvider<CollectionBloc>(
          create: (context) => GetIt.I<CollectionBloc>()..add(FetchCollectionsEvent())),
        BlocProvider<CollectionProductBloc>(
          create: (context) => GetIt.I<CollectionProductBloc>()),
        BlocProvider<OrderCancellationBloc>(
          create: (context) => GetIt.I<OrderCancellationBloc>()),
        BlocProvider<ReturnOrderBloc>(
          create: (context) => GetIt.I<ReturnOrderBloc>()),
        BlocProvider<PaymentIntentBloc>(
          create: (context) => GetIt.I<PaymentIntentBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Awafi Mill',
        theme: ThemeData(),
        home: AnimationExample(), // Set your splash or initial screen here
      ),
    );
  }
}
