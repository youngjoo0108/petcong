import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';

// stomp client
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketService extends ChangeNotifier {
  late StompClient client;
  late List msgArr = [];
  String? idToken;

  SocketService() {
    initSocket();
  }

  static Future<SocketService> create() async {
    var socketService = SocketService();
    await socketService.init();
    return socketService;
  }

  Future<void> init() async {
    idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  Future<void> initSocket() async {
    await init();
    connectSocket();
  }

  void connectSocket() {
    if (idToken == null) {
      debugPrint('idToken is nullllllllllllllllllllllllllllll');
      return;
    }
    debugPrint(
        'I get idToken!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    // 소켓 초기화 및 연결
    client = StompClient(
        config: StompConfig.sockJS(
            url: 'http://i10a603.p.ssafy.io:8080/websocket',
            webSocketConnectHeaders: {
              "Petcong-id-token": idToken,
              "transports": ["websocket"],
            },
            onConnect: (StompFrame frame) {
              notifyListeners();
              debugPrint("연결됨");
              client.subscribe(
                destination: '/queue/1/',
                headers: {
                  "tester": "A603",
                },
                callback: (frame) {
                  msgArr.add(frame.body!);
                  notifyListeners();
                },
              );
            },
            onWebSocketError: (dynamic error) =>
                debugPrint('websocketerror : $error')));
    client.activate();
    debugPrint(
        '---------------------------------${client.isActive}-----------------------------------------');
    notifyListeners();
  }

  void disposeSocket() {
    // 소켓 종료 및 정리
    client.deactivate();
    idToken = null;
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
