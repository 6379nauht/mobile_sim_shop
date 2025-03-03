import 'package:equatable/equatable.dart';

class CarouselState extends Equatable {
  final int currentIndex;
  const CarouselState({required this.currentIndex});

  @override
  List<Object?> get props => [currentIndex];

}