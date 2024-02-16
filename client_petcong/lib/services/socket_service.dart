import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:petcong/controller/call_wait_controller.dart';
import 'package:petcong/models/card_profile_model.dart';
import 'package:petcong/pages/app_pages/matching/call_waiting_page.dart';
import 'package:petcong/pages/app_pages/webRTC/webrtc.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

// stomp client
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketService extends GetxController {
  // Socket 변수
  static StompClient? client;
  RxList<String> msgArr = <String>[].obs;
  static String?
      uid; // initPrefs()에서 late init 된 후, 바뀌지 않을 값 / static 함수에서 사용함.
  String? idToken;
  User user = FirebaseAuth.instance.currentUser!;
  VoidCallback? onInitComplete;
  static late String targetUid; // matched 메시지 받았을 때 초기화됨. static 함수에서 사용함.
  String subsPrefix = "/queue/";
  static bool callPressed = false;
  List<RTCIceCandidate>? iceCandidates;
  MainVideoCallWidget?
      mainVideoCallWidget; // 인스턴스 변수로 들고있고, callWaiting 진입 / 통화종료 시 생성/삭제 (동시에 한 통화만 가능하므로 겹칠 일 X)

  Future<void> initPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      uid = prefs.getString('uid');
      await user.getIdToken().then((result) {
        idToken = result;
      });
    } catch (e) {
      debugPrint('Error retrieving values from SharedPreferences: $e');
    }
  }

  void setCallPressed(bool flag) {
    callPressed = flag;
  }

  void sendAllIces() {
    List<RTCIceCandidate> ices = mainVideoCallWidget!.getIceCandidates();
    for (var ice in ices) {
      sendIce(ice);
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
      debugPrint(uid);
    } catch (e) {
      debugPrint('Error during initialization: $e');
    }
  }

  Future<StompClient> initSocket() async {
    if (client != null) {
      return client!;
    }

    initPrefs();
    if (client == null) {
      client = StompClient(
        config: StompConfig.sockJS(
          url: 'https://i10a603.p.ssafy.io/websocket',
          webSocketConnectHeaders: {
            // "Petcong-id-token": idToken,
            "transports": ["websocket"],
          },
          onConnect: (StompFrame frame) {
            debugPrint("연결됨");
            client!.subscribe(
              destination: '/queue/$uid',
              headers: {
                "uid": uid!,
              },
              callback: (frame) async {
                if (frame.body!.isNotEmpty) {
                  msgArr.add(frame.body!);
                  Map<String, dynamic> response = jsonDecode(frame.body!);

                  String type = response['type'];
                  debugPrint('type = $type');

                  switch (type) {
                    case 'matched':
                      Map<String, dynamic> value = response['value'];
                      // 전화 오는 화면으로 이동만. rtc 연결은 요청했던 쪽의 sendOffer로 시작해서 진행됨.
                      CardWaitController cardWaitController = Get.find();
                      targetUid = response['targetUid'];
                      CardProfileModel targetUserInfo =
                          CardProfileModel.fromJson(value);
                      cardWaitController.setCardProfile(targetUserInfo);
                      await makeCall(targetUid);
                      break;

                    case 'offer':
                      Map<String, dynamic> value =
                          jsonDecode(response['value']);

                      value.forEach((key, value) {
                        debugPrint('Key: $key, Value: $value');
                      });
                      await gotOffer(value['sdp'], value['type']);
                      await sendAnswer();
                      await Future.delayed(const Duration(milliseconds: 300));
                      sendAllIces();
                      break;

                    case 'answer':
                      Map<String, dynamic> value =
                          jsonDecode(response['value']);
                      await gotAnswer(value['sdp'], value['type']);
                      sendAllIces();
                      break;

                    case 'ice':
                      Map<String, dynamic> value =
                          jsonDecode(response['value']);

                      gotIce(value['candidate'], value['sdpMid'],
                          value['sdpMLineIndex']);
                      break;
                    case 'block':
                      debugPrint("sendOffer blocked!");
                      callPressed = true;
                      break;

                    case 'idx':
                      int newIdx = int.parse(response['value']);
                      mainVideoCallWidget!.quizIdx?.value = newIdx;
                      break;
                  }
                }
              },
            );
          },
          onWebSocketError: (dynamic error) =>
              debugPrint('websocketerror : $error'),
        ),
      );
      await activateSocket(client!);
      if (kDebugMode) {
        print('activating socket');
      }
      await Future.delayed(const Duration(milliseconds: 300));
    }
    if (kDebugMode) {
      print(
          " socketService.initSocket, client.hashCode() = ${client.hashCode} ${client!.connected}");
    }
    return client!;
  }

  Future<void> initRTCWidget() async {
    mainVideoCallWidget = MainVideoCallWidget();
    await mainVideoCallWidget!.init();
  }

  Future<void> makeCall(String targetUidParam) async {
    targetUid = targetUidParam;
    // matched
    // 전화 오는 화면으로
    await initRTCWidget();
    Get.to(CallWaiting(this, mainVideoCallWidget!));
  }

  Future<void> activateSocket(StompClient client) async {
    client.activate();
  }

  Future<void> onCallPressed() async {
    await sendOffer(targetUid);
    await Future.delayed(const Duration(seconds: 5));

    Get.to(
      mainVideoCallWidget,
    );
  }

  Future<void> disposeSocket(myuid) async {
    String stringUid = myuid as String;
    try {
      if (client!.isActive == true) {
        debugPrint('Before sending message: Socket is active');
        client!.send(
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
      client!.deactivate();
      client = null;
      debugPrint('연결끔');
    } catch (e) {
      debugPrint('Error disposing socket: $e');
    }
  }

  static void sendMessage(String type, String value) {
    client!.send(
        destination: '/queue/$targetUid',
        headers: {
          "content-type": "application/json",
          "uid": uid.toString(),
          "info": "connect"
        },
        body: jsonEncode({"type": type, "value": value}));
  }

  Future sendOffer(String targetUidLocal) async {
    if (callPressed) {
      // 상대방이 call버튼을 먼저 눌러서 gotOffer를 받았다면, 중복 send 방지
      return;
    }
    callPressed = true;
    // block target's sendOffer
    sendMessage("block", ".");
    await mainVideoCallWidget!.joinRoom();
    await Future.delayed(const Duration(milliseconds: 500));

    targetUid = targetUidLocal;

    await Future.delayed(const Duration(milliseconds: 1000));

    var offer = await mainVideoCallWidget!.createOffer();
    mainVideoCallWidget!.setLocalDescription(offer);
    sendMessage("offer", jsonEncode(offer.toMap()));
  }

  Future gotOffer(String sdp, String type) async {
    update();
    await mainVideoCallWidget!.joinRoom();
    await Future.delayed(const Duration(milliseconds: 500));
    RTCSessionDescription offer = RTCSessionDescription(sdp, type);
    mainVideoCallWidget!.setRemoteDescription(offer);
    callPressed = true;
  }

  Future sendAnswer() async {
    var answer = await mainVideoCallWidget!.createAnswer();
    mainVideoCallWidget!.setLocalDescription(answer);
    sendMessage("answer", jsonEncode(answer.toMap()));
  }

  Future gotAnswer(String sdp, String type) async {
    update();
    RTCSessionDescription answer = RTCSessionDescription(sdp, type);
    mainVideoCallWidget!.setRemoteDescription(answer);
  }

  Future sendIce(RTCIceCandidate ice) async {
    update();
    sendMessage("ice", jsonEncode(ice.toMap()));
  }

  Future gotIce(String candidate, String sdpMid, int sdpMLineIndex) async {
    update();
    RTCIceCandidate ice = RTCIceCandidate(candidate, sdpMid, sdpMLineIndex);
    mainVideoCallWidget!.addCandidate(ice);
  }
}
