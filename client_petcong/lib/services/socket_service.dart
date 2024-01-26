import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stomp_dart_client/stomp.dart';

// stomp client
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketService extends ChangeNotifier {
  late StompClient client;
  late List msgArr = [];
  // late final _userId;
  SocketService() {
    connectSocket();
  }

  void connectSocket() {
    // 소켓 초기화 및 연결
    client = StompClient(
        config: StompConfig.sockJS(
            url: 'http://localhost:8080/websocket',
            webSocketConnectHeaders: {
              "transports": ["websocket"],
            },
            onConnect: (StompFrame frame) {
              notifyListeners();
              debugPrint("연결됨");
              client.subscribe(
                destination: '/queue/1/',
                headers: {},
                callback: (frame) {
                  msgArr.add(frame.body!);
                  notifyListeners();
                },
              );
            },
            onWebSocketError: (dynamic error) =>
                debugPrint('websocketerror : $error')));
    //stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
    //webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
    client.activate();
    debugPrint(
        '---------------------------------${client.isActive}-----------------------------------------');
    notifyListeners();
  }

  void disposeSocket() {
    // 소켓 종료 및 정리
    client.deactivate();
    // notifyListeners();
    debugPrint('연결끔');
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
