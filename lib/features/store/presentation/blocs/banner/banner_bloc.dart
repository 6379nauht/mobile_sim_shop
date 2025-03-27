import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/get_all_banners_usecase.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/banner/banner_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/banner/banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final GetAllBannersUsecase _getAllBannersUsecase;
  BannerBloc(this._getAllBannersUsecase) : super(const BannerState()) {
    on<LoadBanners>(_onLoadBanners);
  }

  Future<void> _onLoadBanners(
      LoadBanners event, Emitter<BannerState> emit) async {
    emit(state.copyWith(status: BannerStatus.loading));

    final result = await _getAllBannersUsecase.call(params: NoParams());

    result.fold((failure) {
      emit(state.copyWith(status: BannerStatus.failure, errorMessage: failure.message));

    }, (banners) {
      emit(state.copyWith(
        status: BannerStatus.success,
        banners: banners
      ));
    });
  }
}
