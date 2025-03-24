import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/banner/banner_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/banner/banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  BannerBloc() : super(const BannerState()) {
    on<LoadBanners>(_onLoadBanners);
  }

  Future<void> _onLoadBanners(LoadBanners event, Emitter<BannerState> emit) async{
    emit(state.copyWith(status: BannerStatus.loading));
  }
}