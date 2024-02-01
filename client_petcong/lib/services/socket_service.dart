import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

// stomp client
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketService extends GetxService {
  StompClient? client;
  RxList<String> msgArr = <String>[].obs;
  String? uid;
  String? idToken;
  VoidCallback? onInitComplete;

  Future<void> initPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      uid = prefs.getString('uid');
      idToken = prefs.getString('idToken');
      // debugPrint('uid : $uid, idToken : $idToken');
    } catch (e) {
      debugPrint('Error retrieving values from SharedPreferences: $e');
    }
  }

  Future<void> init() async {
    try {
      await initPrefs();
      if (idToken == null) {
        debugPrint('idToken is null');
        return;
      }
      await initSocket();
      print('2222222222222222222222${client?.config}22222222222222222222222');

      if (onInitComplete != null) {
        onInitComplete!(); // Notify the callback
      }

      debugPrint('!!!!!!!!!!!!!!!!!!!!!I get IdToken!!!!!!!!!!!!!!');
    } catch (e) {
      debugPrint('Error during initialization: $e');
    }
  }

  Future<void> initSocket() async {
    client = StompClient(
      config: StompConfig.sockJS(
        url: 'http://i10a603.p.ssafy.io:8081/websocket',
        webSocketConnectHeaders: {
          // "Petcong-id-token": idToken,
          "transports": ["websocket"],
        },
        onConnect: (StompFrame frame) {
          debugPrint("연결됨");
          client!.subscribe(
            destination: '/queue/$uid',
            headers: {
              "uid": uid ?? "",
            },
            callback: (frame) {
              msgArr.add(frame.body!);
            },
          );
          debugPrint('i cant found');
        },
        onDisconnect: (StompFrame frame) {
          debugPrint('화장실왜감');
        },
        onWebSocketError: (dynamic error) =>
            debugPrint('websocketerror : $error'),
      ),
    );

    client!.activate();
    // final prefs = await SharedPreferences.getInstance();
    // prefs.get('client' : client);

    print(
        '111111111111111111111111111111111${client?.config}111111111111111111111111111111111');
  }

  Future<void> disposeSocket() async {
    print(client?.connected);
    print(client?.isActive);
    try {
      if (client!.connected) {
        debugPrint('Before sending message: Socket is active');
        client!.send(
          destination: '/queue/$uid',
          headers: {
            "content-type": "application/json",
            "uid": uid ?? "",
            "info": "disconnect",
          },
          body: "",
        );
        debugPrint('Message sent to server');
      } else {
        debugPrint('Before sending message: Socket is not active');
      }

      // 클라이언트를 비활성화하기 전에 지연을 도입
      await Future.delayed(const Duration(seconds: 1));

      client!.deactivate();
      debugPrint('After deactivating: Is client active? ${client?.connected}');
      idToken = null;
      uid = null;
      debugPrint(idToken);
    } catch (e) {
      debugPrint('Error disposing socket: $e');
    }
  }
}
