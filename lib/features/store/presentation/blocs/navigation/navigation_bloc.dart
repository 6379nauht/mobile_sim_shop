import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/navigation/navigation_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/navigation/navigation_state.dart';


class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState(selectedIndex: 0)) {
    on<NavigationEvent>((event, emit) {
      if (event is ChangeTabEvent) {
        emit(NavigationState(selectedIndex: event.index));
      }
    });
  }

}