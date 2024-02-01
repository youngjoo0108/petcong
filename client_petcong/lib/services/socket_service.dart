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
      if (onInitComplete != null) {
        onInitComplete!();
      }
      debugPrint('!!!!!!!!!!!!!!!!!!!!!I get IdToken!!!!!!!!!!!!!!');
    } catch (e) {
      debugPrint('Error during initialization: $e');
    }
  }

  StompClient initSocket() {
    initPrefs();
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
        },
        onWebSocketError: (dynamic error) =>
            debugPrint('websocketerror : $error'),
      ),
    );

    return client!;
  }

  Future<void> disposeSocket(myclient, myuid) async {
    String stringUid = myuid as String;
    try {
      if (myclient.isActive == true) {
        debugPrint('Before sending message: Socket is active');
        myclient!.send(
          destination: '/queue/$stringUid',
          headers: {
            "content-type": "application/json",
            "uid": stringUid,
            "info": "disconnect",
          },
          body: "",
        );
        debugPrint('Message sent to server');
      } else {
        debugPrint('Before sending message: Socket is not active');
      }

      myclient!.deactivate();
      debugPrint('After deactivating: Is client active? ${myclient?.isActive}');
    } catch (e) {
      debugPrint('Error disposing socket: $e');
    }
  }
}
