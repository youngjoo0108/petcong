import 'package:flutter/material.dart';
import 'package:petcong/controller/user_controller.dart';
import 'package:stomp_dart_client/stomp.dart';

// stomp client
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketService extends ChangeNotifier {
  late StompClient client = StompClient(
    config: const StompConfig(
      // url: 'http://i10a603.p.ssafy.io:8080/websocket',
      url: 'http://43.200.28.137:8080/websocket',
    ),
  );
  late List msgArr = [];
  UserController userController = UserController.instance;
  String? uid;
  String? idToken;

  SocketService() {
    initSocket();
  }

  static Future<SocketService> create() async {
    var socketService = SocketService();
    await socketService.init();
    return socketService;
  }

  Future<void> initSocket() async {
    uid = userController.uid;
    idToken = userController.idToken;
    connectSocket();
  }

  void connectSocket() async {
    if (idToken == null) {
      debugPrint('idToken is null');
      return;
    }
    if (client.isActive) {
      debugPrint('Socket already connected');
      return;
    }

    // 소켓 초기화 및 연결
    client = StompClient(
      config: StompConfig.sockJS(
        // url: 'http://i10a603.p.ssafy.io:8080/websocket',
        url: 'http://43.200.28.137:8080/websocket',
        webSocketConnectHeaders: {
          "Petcong-id-token": idToken,
          "transports": ["websocket"],
        },
        onConnect: (StompFrame frame) {
          notifyListeners();
          debugPrint("연결됨");
          client.subscribe(
            destination: '/queue/$uid',
            headers: {
              "uid": uid ?? "",
            },
            callback: (frame) {
              msgArr.add(frame.body!);
              notifyListeners();
            },
          );
        },
        onWebSocketError: (dynamic error) =>
            debugPrint('websocketerror : $error'),
      ),
    );
    client.activate();
    notifyListeners();
  }

  // 소켓 종료 및 정리
  void disposeSocket() async {
    try {
      client.send(
        destination: '/queue/$uid',
        headers: {
          "content-type": "application/json",
          "uid": uid ?? "",
          "info": "disconnect",
        },
        body: "",
      );
    } catch (error) {
      print("Error sending message: $error");
    }
    client.deactivate();
    debugPrint('연결끔');
  }

  init() {}
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
