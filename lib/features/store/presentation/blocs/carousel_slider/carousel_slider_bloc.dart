import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/carousel_slider/carousel_slider_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/carousel_slider/carousel_slider_state.dart';

class CarouselBloc extends Bloc<CarouselEvent, CarouselState> {
  CarouselBloc() : super(const CarouselState(currentIndex: 0)) {
    on<ChangeSliderEvent>((event, emit) {
      emit(CarouselState(currentIndex: event.newIndex));
    });
  }

}