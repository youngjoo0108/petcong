import 'package:flutter/material.dart';
import 'package:petcong/controller/user_controller.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:shared_preferences/shared_preferences.dart';

// stomp client
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketService extends ChangeNotifier {
  // late StompClient client = StompClient(
  //   config: const StompConfig(
  //     url: 'http://i10a603.p.ssafy.io:8080/websocket',
  //   ),
  // );
  late StompClient client = StompClient(config: const StompConfig(url: ''));
  late List msgArr = [];
  String? uid;
  String? idToken;

  Future<void> initPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      uid = prefs.getString('uid');
      idToken = prefs.getString('idToken');
    } catch (e) {
      print('Error retrieving values from SharedPreferences: $e');
    }
  }

  SocketService() {
    init();
  }

  Future<void> init() async {
    try {
      await initPrefs();
      if (idToken == null) {
        debugPrint('idToken is null');
        return;
      }
      await initSocket();
      print('!!!!!!!!!!!!!!!!!!!!!I get IdToken!!!!!!!!!!!!!!');
    } catch (e) {
      print('Error during initialization: $e');
    }
  }

  Future<void> initSocket() async {
    try {
      if (idToken == null) {
        debugPrint('idToken is null');
        return;
      }
      if (client.isActive) {
        debugPrint('Socket already connected');
        return;
      }
      print(uid);

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
      print(
          '----------------------------------${client.isActive}--------------');
      notifyListeners();
    } catch (e) {
      print('Error initializing socket: $e');
    }
  }

  Future<void> disposeSocket() async {
    try {
      if (client.isActive) {
        print('before send');
        client.send(
          destination: '/queue/$uid',
          headers: {
            "content-type": "application/json",
            "uid": uid ?? "",
            "info": "disconnect",
          },
          body: "",
        );
        print('Message sent to server');
      } else {
        debugPrint('Socket is not active');
      }

      client.deactivate();
      debugPrint('Is client active after deactivation? ${client.isActive}');
      idToken = null;
      debugPrint(idToken);
    } catch (e) {
      print('Error disposing socket: $e');
    }
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
