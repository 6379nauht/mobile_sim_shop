import 'package:equatable/equatable.dart';
import 'package:mobile_sim_shop/features/store/data/models/banner_model.dart';

enum BannerStatus { initial, loading, success, failure }

class BannerState extends Equatable {
  final BannerStatus status;
  final String? errorMessage;
  final List<BannerModel> banners;

  const BannerState(
      {this.status = BannerStatus.initial,
      this.banners = const [],
      this.errorMessage});

  BannerState copyWith(
      {BannerStatus? status,
      String? errorMessage,
      List<BannerModel>? banners}) {
    return BannerState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        banners: banners ?? this.banners);
  }

  @override
  List<Object?> get props => [status, errorMessage, banners];
}
