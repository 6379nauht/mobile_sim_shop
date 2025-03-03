import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'network_event.dart';
import 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  StreamSubscription? subscription;
  NetworkBloc() : super(NetworkInitial()) {
    on<OnConnected>(
        (event, emit) => emit(NetworkConnected(msg: "Connected......")));
    on<OnNotConnected>(
        (event, emit) => emit(NetworkDisconnected(msg: "Disconnected......")));
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.wifi) || results.contains(ConnectivityResult.mobile)) {
        add(OnConnected());
      } else {
        add(OnNotConnected());
      }
    });

  }

  @override
  Future<void> close() {
    subscription?.cancel(); // Hủy lắng nghe khi Bloc bị đóng
    return super.close();
  }
}
