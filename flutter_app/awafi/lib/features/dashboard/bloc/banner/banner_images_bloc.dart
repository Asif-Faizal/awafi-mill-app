import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/banner/banner_entity.dart';
import '../../domain/banner/get_banner.dart';

part 'banner_images_event.dart';
part 'banner_images_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final GetBannersUseCase getBannersUseCase;
  final GetOfferBannersUseCase getOfferBannersUseCase;
  final GetCollectionBannersUseCase getCollectionBannersUseCase;

  BannerBloc({
    required this.getBannersUseCase,
    required this.getOfferBannersUseCase,
    required this.getCollectionBannersUseCase,
  }) : super(BannerInitial()) {
    on<LoadBannersEvent>(_onLoadBanners);
    on<LoadOfferBannersEvent>(_onLoadOfferBanners);
    on<LoadCollectionBannersEvent>(_onLoadCollectionBanners);
  }

  Future<void> _onLoadBanners(LoadBannersEvent event, Emitter<BannerState> emit) async {
    emit(BannerLoading());
    try {
      final banners = await getBannersUseCase();
      emit(BannerLoaded(banners));
    } catch (e) {
      emit(BannerError('Failed to load banners'));
    }
  }

  Future<void> _onLoadOfferBanners(LoadOfferBannersEvent event, Emitter<BannerState> emit) async {
    emit(BannerLoading());
    try {
      final offerBanners = await getOfferBannersUseCase();
      emit(BannerLoaded(offerBanners));
    } catch (e) {
      emit(BannerError('Failed to load offer banners'));
    }
  }

  Future<void> _onLoadCollectionBanners(LoadCollectionBannersEvent event, Emitter<BannerState> emit) async {
    emit(BannerLoading());
    try {
      final collectionBanners = await getCollectionBannersUseCase();
      emit(BannerLoaded(collectionBanners));
    } catch (e) {
      emit(BannerError('Failed to load collection banners'));
    }
  }
}
