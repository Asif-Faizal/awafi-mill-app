import 'package:awafi/features/dashboard/data/collectionProducts/collection_product_datasource.dart';
import 'package:awafi/features/dashboard/data/collectionProducts/collection_product_repo_impl.dart';
import 'package:awafi/features/dashboard/domain/collectionProducts/collection_product_repo.dart';
import 'package:awafi/features/dashboard/domain/sub_category_product/sub_category_product_repo.dart';
import 'package:awafi/features/dashboard/domain/userData/edit_profile.dart';
import 'package:awafi/features/login/bloc/login_input/login_input_bloc.dart';
import 'package:awafi/features/signup/bloc/signup_input/signup_input_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../features/connection/bloc/connectivity_bloc.dart';
import '../../features/dashboard/bloc/addAddress/add_address_bloc.dart';
import '../../features/dashboard/bloc/addCart/add_cart_bloc.dart';
import '../../features/dashboard/bloc/address/address_bloc.dart';
import '../../features/dashboard/bloc/banner/banner_images_bloc.dart';
import '../../features/dashboard/bloc/bottom_nav_bar/bottom_navigation_bar_bloc.dart';
import '../../features/dashboard/bloc/cart/cart_bloc.dart';
import '../../features/dashboard/bloc/category/category_bloc.dart';
import '../../features/dashboard/bloc/checkout/checkout_bloc.dart';
import '../../features/dashboard/bloc/collection/collections_bloc.dart';
import '../../features/dashboard/bloc/collectionProducts/collection_products_bloc.dart';
import '../../features/dashboard/bloc/payment_intent/payment_intent_bloc.dart';
import '../../features/dashboard/bloc/product/product_bloc.dart';
import '../../features/dashboard/bloc/product_details/product_details_bloc.dart';
import '../../features/dashboard/bloc/subCategory/sub_category_bloc.dart';
import '../../features/dashboard/bloc/sub_category_product/sub_category_product_bloc.dart';
import '../../features/dashboard/bloc/toggle_wishlist/toggle_wishlist_bloc.dart';
import '../../features/dashboard/bloc/userData/user_data_bloc.dart';
import '../../features/dashboard/bloc/wishlist/wishlist_bloc.dart';
import '../../features/dashboard/data/addAddress/add_address_datasource.dart';
import '../../features/dashboard/data/addAddress/add_address_repo_implp.dart';
import '../../features/dashboard/data/addCart/add_cart_datasource.dart';
import '../../features/dashboard/data/addCart/add_cart_repo_impl.dart';
import '../../features/dashboard/data/address/address_datasource.dart';
import '../../features/dashboard/data/address/address_repo_impl.dart';
import '../../features/dashboard/data/banner/banner_datasource.dart';
import '../../features/dashboard/data/banner/banner_repo_impl.dart';
import '../../features/dashboard/data/cart/cart_datasource.dart';
import '../../features/dashboard/data/cart/cart_repo_impl.dart';
import '../../features/dashboard/data/category/category_datasource.dart';
import '../../features/dashboard/data/category/category_repo_impl.dart';
import '../../features/dashboard/data/checkout/checkout_datasource.dart';
import '../../features/dashboard/data/checkout/checkout_repo_impl.dart';
import '../../features/dashboard/data/collection/collection_datasource.dart';
import '../../features/dashboard/data/collection/collection_repo_impl.dart';
import '../../features/dashboard/data/product/product_datasource.dart';
import '../../features/dashboard/data/product/product_repo_impl.dart';
import '../../features/dashboard/data/product_details/product_details_datasource.dart';
import '../../features/dashboard/data/product_details/product_details_repo_impl.dart';
import '../../features/dashboard/data/refresh/refresh_datasource.dart';
import '../../features/dashboard/data/subCategory/subCategory_datasource.dart';
import '../../features/dashboard/data/subCategory/subCategory_repo_impl.dart';
import '../../features/dashboard/data/sub_category_product/sub_category_product_datasource.dart';
import '../../features/dashboard/data/sub_category_product/sub_category_product_repo_impl.dart';
import '../../features/dashboard/data/toggle_wishlist/toggle_wishlist_datasource.dart';
import '../../features/dashboard/data/toggle_wishlist/toggle_wishlist_repo_impl.dart';
import '../../features/dashboard/data/userData/userData_datasource.dart';
import '../../features/dashboard/data/userData/userData_repo_impl.dart';
import '../../features/dashboard/data/wishlist/wishlist_datasource.dart';
import '../../features/dashboard/data/wishlist/wishlist_repo_impl.dart';
import '../../features/dashboard/domain/addAddress/add_address.dart';
import '../../features/dashboard/domain/addAddress/add_address_repo.dart';
import '../../features/dashboard/domain/addCart/add_cart_repo.dart';
import '../../features/dashboard/domain/addCart/add_to_cart.dart';
import '../../features/dashboard/domain/address/address_repo.dart';
import '../../features/dashboard/domain/address/get_address.dart';
import '../../features/dashboard/domain/banner/banner_repo.dart';
import '../../features/dashboard/domain/banner/get_banner.dart';
import '../../features/dashboard/domain/cart/cart_repo.dart';
import '../../features/dashboard/domain/cart/get_cart_items.dart';
import '../../features/dashboard/domain/category/category_repo.dart';
import '../../features/dashboard/domain/category/fetch_category.dart';
import '../../features/dashboard/domain/checkout/checkout.dart';
import '../../features/dashboard/domain/checkout/checkout_repo.dart';
import '../../features/dashboard/domain/collection/collection_repo.dart';
import '../../features/dashboard/domain/collection/get_collections.dart';
import '../../features/dashboard/domain/collectionProducts/get_collection_products.dart';
import '../../features/dashboard/domain/product/get_product.dart';
import '../../features/dashboard/domain/product/product_repo.dart';
import '../../features/dashboard/domain/product_details/get_product_details.dart';
import '../../features/dashboard/domain/product_details/product_details_repo.dart';
import '../../features/dashboard/domain/subCategory/get_subCategories.dart';
import '../../features/dashboard/domain/subCategory/subCategory_repo.dart';
import '../../features/dashboard/domain/sub_category_product/fetch_sub_category_products.dart';
import '../../features/dashboard/domain/toggle_wishlist/add_to_wishlist.dart';
import '../../features/dashboard/domain/toggle_wishlist/remove_item_from_wishlist.dart';
import '../../features/dashboard/domain/toggle_wishlist/toggle_wishlist_repo.dart';
import '../../features/dashboard/domain/userData/get_profile.dart';
import '../../features/dashboard/domain/userData/userData_repo.dart';
import '../../features/dashboard/domain/wishlist/get_wishlist.dart';
import '../../features/dashboard/domain/wishlist/wishlist_repo.dart';
import '../../features/login/bloc/forgot_password/forgot_password_bloc.dart';
import '../../features/login/bloc/login/login_bloc.dart';
import '../../features/login/data/forgot_password/forgot_password_datasource.dart';
import '../../features/login/data/forgot_password/forgot_password_repo_impl.dart';
import '../../features/login/data/login/login_datasource.dart';
import '../../features/login/data/login/login_repo_impl.dart';
import '../../features/login/domain/forgot_password/change_password.dart';
import '../../features/login/domain/forgot_password/forgot_passcode_repo.dart';
import '../../features/login/domain/forgot_password/forgot_password.dart';
import '../../features/login/domain/forgot_password/verify_password_otp.dart';
import '../../features/login/domain/login/login.dart';
import '../../features/login/domain/login/login_repo.dart';
import '../../features/notification/bloc/notification_bloc.dart';
import '../../features/orders/bloc/cancel_order/cancel_order_bloc.dart';
import '../../features/orders/bloc/order/orders_bloc.dart';
import '../../features/orders/bloc/return_order/return_order_bloc.dart';
import '../../features/orders/data/purchase_history/order_datasource.dart';
import '../../features/orders/data/purchase_history/order_repo_impl.dart';
import '../../features/orders/domain/purchase_history/fetch_orders.dart';
import '../../features/orders/domain/purchase_history/order_repo.dart';
import '../../features/signup/bloc/register/register_bloc.dart';
import '../../features/signup/data/sign_in_datasource.dart';
import '../../features/signup/data/sign_in_repo_impl.dart';
import '../../features/signup/domain/register_user.dart';
import '../../features/signup/domain/sign_in_repo.dart';
import '../../features/signup/domain/verify_otp.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerFactory(() => BottomNavigationBloc());
  getIt.registerFactory(() => LoginInputBloc());
  getIt.registerFactory(() => CountryCodeBloc());
    getIt.registerLazySingleton<http.Client>(() => http.Client());

  getIt.registerLazySingleton<LoginDataSource>(() => LoginDataSourceImpl(client: getIt()));
  getIt.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(dataSource: getIt()));
  
  getIt.registerLazySingleton<LoginWithEmailUseCase>(() => LoginWithEmailUseCase(repository: getIt()));
  getIt.registerLazySingleton<LoginWithNumberUseCase>(() => LoginWithNumberUseCase(repository: getIt()));

  getIt.registerFactory(() => LoginBloc(
    emailUseCase: getIt(),
    numberUseCase: getIt(),
  ));

    getIt.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSource());
  getIt.registerLazySingleton<SignInRepo>(() => SignInRepoImpl(remoteDataSource: getIt()));
  getIt.registerLazySingleton(() => RegisterUser(getIt()));
  getIt.registerLazySingleton(() => VerifyOtp(getIt()));
  getIt.registerFactory(() => UserBloc(
        registerUser: getIt(),
        verifyOtp: getIt(),
      ));

    getIt.registerFactory(() => BannerBloc(
        getBannersUseCase: getIt(),
        getOfferBannersUseCase: getIt(),
        getCollectionBannersUseCase: getIt(),
      ));
        getIt.registerLazySingleton(() => GetBannersUseCase(getIt()));
  getIt.registerLazySingleton(() => GetOfferBannersUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCollectionBannersUseCase(getIt()));
  getIt.registerLazySingleton<BannerRepository>(
    () => BannerRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton(() => BannerRemoteDataSource(getIt()));


    getIt.registerLazySingleton<CategoryRemoteDataSource>(() => CategoryRemoteDataSourceImpl(client: getIt()));
  getIt.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(remoteDataSource: getIt()));
  getIt.registerLazySingleton(() => FetchCategoriesUseCase(getIt()));
  getIt.registerFactory(() => CategoryBloc(fetchCategoriesUseCase: getIt()));


    getIt.registerLazySingleton<ForgotPasswordDatasource>(() => ForgotPasswordDatasourceImpl(client: getIt()));
  getIt.registerLazySingleton<ForgotPasswordRepository>(() => ForgotPasswordRepositoryImpl(datasource: getIt()));
  getIt.registerLazySingleton(() => ForgotPasswordUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => VerifyOtpUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => ChangePasswordUseCase(repository: getIt()));
  getIt.registerFactory(() => ForgotPasswordBloc(
    forgotPasswordUseCase: getIt(),
    verifyOtpUseCase: getIt(),
    changePasswordUseCase: getIt(),
  ));


  getIt.registerLazySingleton(() => ProductDataSource(getIt()));

  // Repositories
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(getIt()));

  // Use cases
  getIt.registerLazySingleton(() => GetProductsUseCase(getIt()));

  // BLoC
  getIt.registerFactory(() => ProductBloc(getIt()));



  //Collection products
getIt.registerFactory(() => CollectionProductBloc(getIt()));

  // Use Case
  getIt.registerLazySingleton(() => GetCollectionProductsUseCase(getIt()));

  // Repository
  getIt.registerLazySingleton<CollectionProductRepository>(
      () => CollectionProductRepositoryImpl(getIt()));

  // Data Source
  getIt.registerLazySingleton<CollectionProductRemoteDataSource>(
      () => CollectionProductRemoteDataSourceImpl(http.Client()));


  getIt.registerLazySingleton<UserDataDatasource>(() => UserDataDatasourceImpl(client: getIt()));
getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(datasource: getIt()));
getIt.registerLazySingleton<GetUserProfileUseCase>(() => GetUserProfileUseCase(userRepository: getIt()));
getIt.registerLazySingleton<EditUserUseCase>(() => EditUserUseCase(repository: getIt()));
getIt.registerFactory(() => UserProfileBloc(getUserProfileUseCase: getIt(),editUserUseCase: getIt()));



getIt.registerFactory(() => GetAddressBloc(getIt()));

  // UseCase
  getIt.registerLazySingleton(() => GetAddressUseCase(getIt()));

  // Repository
  getIt.registerLazySingleton<AddressRepository>(() => AddressRepositoryImpl(getIt()));

  // DataSource
  getIt.registerLazySingleton<AddressDataSource>(() => AddressDataSourceImpl(getIt()));



  getIt.registerLazySingleton<SubCategoryRemoteDataSource>(
      () => SubCategoryRemoteDataSourceImpl(getIt()));

  // Repositories
  getIt.registerLazySingleton<SubCategoryRepository>(
      () => SubCategoryRepositoryImpl(getIt()));

  // Use cases
  getIt.registerLazySingleton(() => GetSubCategories(getIt()));

  // Blocs
  getIt.registerFactory(() => SubCategoryBloc(getIt()));



  getIt.registerLazySingleton<ProductIndividualRemoteDataSource>(
      () => ProductIndividualRemoteDataSourceImpl(client: getIt()));

  // Repositories
  getIt.registerLazySingleton<ProductIndividualRepository>(
      () => ProductIndividualRepositoryImpl(remoteDataSource: getIt()));

  // Use Cases
  getIt.registerLazySingleton(() => GetProductIndividualDetails(getIt()));

  // Blocs
  getIt.registerFactory(() => ProductIndividualBloc(getProductDetails: getIt()));




  getIt.registerLazySingleton<ToggleWishlistRemoteDataSource>(
    () => ToggleWishlistRemoteDataSourceImpl(client: getIt()),
  );

  // Register repositories
  getIt.registerLazySingleton<ToggleWishlistRepository>(
    () => ToggleWishlistRepositoryImpl(remoteDataSource: getIt()),
  );

  // Register use cases
  getIt.registerLazySingleton(() => AddItemToWishlist(getIt()));
  getIt.registerLazySingleton(() => RemoveItemFromWishlist(getIt()));

  // Register BLoC
  getIt.registerFactory(
    () => ToggleWishlistBloc(
      addItemToWishlistUseCase: getIt(),
      removeItemFromWishlistUseCase: getIt(),
    ),
  );



  getIt.registerLazySingleton<WishlistRemoteDataSource>(
      () => WishlistRemoteDataSourceImpl(client: getIt()));
  getIt.registerLazySingleton<WishlistRepository>(
      () => WishlistRepositoryImpl(remoteDataSource: getIt()));
  getIt.registerLazySingleton<GetWishlistItemsUseCase>(
      () => GetWishlistItemsUseCase(repository: getIt()));
  getIt.registerFactory<WishlistBloc>(
      () => WishlistBloc(getWishlistItemsUseCase: getIt()));



  getIt.registerLazySingleton<AddCartDatasource>(() => AddCartDatasourceImpl(client: getIt(),refreshDatasource: getIt()));

  // Repositories
  getIt.registerLazySingleton<AddCartRepo>(() => AddCartRepoImpl(remoteDataSource: getIt()));

  // Use cases
  getIt.registerLazySingleton(() => AddCartItemUseCase(repository: getIt()));

  // Blocs
  getIt.registerFactory(() => AddCartBloc(addCartItemUseCase: getIt()));


  getIt.registerLazySingleton<CartDataSource>(() => CartDataSourceImpl());
  getIt.registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(getIt<CartDataSource>()));
  getIt.registerLazySingleton(() => GetCartItems(getIt<CartRepository>()));
  getIt.registerFactory(() => CartBloc(getIt(), getIt()));


  getIt.registerLazySingleton<AddAddressDatasource>(() => AddAddressDatasourceImpl(client: getIt(),refreshDatasource: getIt()));
  getIt.registerLazySingleton<AddAddressRepository>(() => AddAddressRepositoryImpl(datasource: getIt()));
  getIt.registerLazySingleton<AddAddressUseCase>(() => AddAddressUseCase(repository: getIt()));
  getIt.registerFactory<AddAddressBloc>(() => AddAddressBloc(addAddressUseCase: getIt()));


  getIt.registerLazySingleton<CheckoutRemoteDataSource>(
    () => CheckoutRemoteDataSourceImpl(client: getIt<http.Client>()),
  );

  // Register the repository
  getIt.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepositoryImpl(remoteDataSource: getIt<CheckoutRemoteDataSource>()),
  );

  // Register the use case
  getIt.registerLazySingleton<CheckoutUseCase>(
    () => CheckoutUseCase( getIt<CheckoutRepository>()),
  );

  // Register the bloc
  getIt.registerFactory<CheckoutBloc>(
    () => CheckoutBloc(checkoutUseCase: getIt<CheckoutUseCase>()),
  );


    getIt.registerLazySingleton<SubCategoryProductDatasource>(
    () => SubCategoryProductDatasourceImpl(
      client: getIt(),  // Assuming you're using http client
    ),
  );
  getIt.registerLazySingleton<SubCategoryProductRepo>(() => SubCategoryProductRepoImpl(datasource: getIt()));
  getIt.registerLazySingleton(() => FetchProductsUseCase(repository: getIt()));
  getIt.registerFactory(() => SubCategoryProductBloc(fetchProductsUseCase: getIt()));


  getIt.registerLazySingleton<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(client: getIt()));

  // Repository
  getIt.registerLazySingleton<OrderRepository>(
      () => OrderRepositoryImpl(dataSource: getIt()));

  // Use Cases
  getIt.registerLazySingleton(() => FetchOrdersUseCase(repository: getIt()));

  // BLoC
  getIt.registerFactory(() => OrdersBloc(fetchOrdersUseCase: getIt()));


  getIt.registerLazySingleton<ConnectivityBloc>(() => ConnectivityBloc());


  //notification
  getIt.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);

  // Register NotificationBloc
  getIt.registerFactory<NotificationBloc>(
    () => NotificationBloc(firebaseMessaging: getIt<FirebaseMessaging>()),
  );



  getIt.registerFactory(() => CollectionBloc(getCollectionsUseCase: getIt()));

  // Use Cases
  getIt.registerLazySingleton(() => GetCollectionsUseCase(repository: getIt()));

  // Repository
  getIt.registerLazySingleton<CollectionRepository>(
      () => CollectionRepositoryImpl(remoteDataSource: getIt()));

  // Data Source
  getIt.registerLazySingleton<CollectionRemoteDataSource>(
      () => CollectionRemoteDataSourceImpl(client: getIt()));


  getIt.registerFactory<OrderCancellationBloc>(() => OrderCancellationBloc());

   getIt.registerFactory<ReturnOrderBloc>(() => ReturnOrderBloc());

  getIt.registerLazySingleton<RefreshDatasource>(() => RefreshDatasource());

  // Payment Intent
  getIt.registerLazySingleton<PaymentIntentBloc>(
    () => PaymentIntentBloc(),
  );

}