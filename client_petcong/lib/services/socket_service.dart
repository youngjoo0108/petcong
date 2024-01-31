import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

// stomp client
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketService extends GetxService {
  late StompClient client;
  RxList<String> msgArr = <String>[].obs;
  String? uid;
  String? idToken;

  Future<void> initPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      uid = prefs.getString('uid');
      idToken = prefs.getString('idToken');
      print('uid : $uid, idToken : $idToken');
    } catch (e) {
      print('Error retrieving values from SharedPreferences: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    try {
      await initPrefs();
      if (idToken == null) {
        print('idToken is null');
        return;
      }
      await initSocket();
      print('!!!!!!!!!!!!!!!!!!!!!I get IdToken!!!!!!!!!!!!!!');
    } catch (e) {
      print('Error during initialization: $e');
    }
  }

  Future<void> initSocket() async {
    print('????????????????????????????????????????????????????????????');

    client = StompClient(
      config: StompConfig.sockJS(
        url: 'http://i10a603.p.ssafy.io:8080/websocket',
        webSocketConnectHeaders: {
          "Petcong-id-token": idToken,
          "transports": ["websocket"],
        },
        onConnect: (StompFrame frame) {
          debugPrint("연결됨");
          client.subscribe(
            destination: '/queue/$uid',
            headers: {
              "uid": uid ?? "",
            },
            callback: (frame) {
              msgArr.add(frame.body!);
            },
          );
        },
        onWebSocketError: (dynamic error) =>
            debugPrint('websocketerror : $error'),
      ),
    );

    client.activate();
    print(
        '---------------------------------------------${client.isActive}--------------------------------------------');
  }

  Future<void> disposeSocket() async {
    try {
      if (client.isActive) {
        print('Before sending message: Socket is active');
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
        print('Before sending message: Socket is not active');
      }

      // 클라이언트를 비활성화하기 전에 지연을 도입
      await Future.delayed(const Duration(seconds: 1));

      // 항상 클라이언트를 비활성화하십시오. 활성 상태 여부에 상관없이
      client.deactivate();
      print('After deactivating: Is client active? ${client.isActive}');
      idToken = null;
      uid = null;
      print(idToken);
    } catch (e) {
      print('Error disposing socket: $e');
    }
  }
}
