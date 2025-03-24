import 'package:equatable/equatable.dart';

abstract class CarouselEvent extends Equatable {
  const CarouselEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChangeSliderEvent extends CarouselEvent {
  final int newIndex;
  const ChangeSliderEvent({required this.newIndex});

  @override
  List<Object?> get props => [newIndex];
}