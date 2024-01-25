import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';

// stomp client
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketService extends ChangeNotifier {
  late StompClient client;

  SocketService() {
    connectSocket();
  }

  void connectSocket() {
    // 소켓 초기화 및 연결
    client = StompClient(
        config: StompConfig.sockJS(
            url: 'http://localhost:3000/',
            webSocketConnectHeaders: {
              "transports": ["websocket"],
            },
            onConnect: (StompFrame frame) {
              notifyListeners();
              print("연결됨");
            },
            onWebSocketError: (dynamic error) => print(error.toString())));

    client.activate();
    notifyListeners();
  }

  void disposeSocket() {
    // 소켓 종료 및 정리
    client.deactivate();
    notifyListeners();
  }
}

class SocketServiceProvider extends InheritedWidget {
  final SocketService socketService;

  const SocketServiceProvider({
    super.key,
    required Widget child,
    required this.socketService,
  }) : super(child: child);

  static SocketServiceProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SocketServiceProvider>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
