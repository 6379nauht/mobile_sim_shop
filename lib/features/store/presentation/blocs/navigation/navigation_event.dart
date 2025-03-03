

import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props =>[];
}

class ChangeTabEvent extends NavigationEvent {
  final int index;
  const ChangeTabEvent({required this.index});

  @override
  List<Object> get props => [index];
}