
abstract class NetworkState {

}

class NetworkInitial extends NetworkState {}

class NetworkConnected extends NetworkState {
  String msg;
  NetworkConnected({required this.msg});
}

class NetworkDisconnected extends NetworkState {
  String msg;
  NetworkDisconnected({required this.msg});
}
