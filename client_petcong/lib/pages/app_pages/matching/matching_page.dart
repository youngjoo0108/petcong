import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcong/controller/match_card_controller.dart';
import 'package:petcong/models/choice_res.dart';
import 'package:petcong/services/socket_service.dart';
import 'package:petcong/services/matching_service.dart';
import 'package:petcong/widgets/card_overlay.dart';
import 'package:petcong/widgets/matching_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:swipable_stack/swipable_stack.dart';

class MainMatchingPage extends StatefulWidget {
  final SocketService?
      socketService; // HomePage -> _MainMatchingPageState로의 전달을 위함
  const MainMatchingPage({Key? key, this.socketService}) : super(key: key);

  @override
  State<MainMatchingPage> createState() => _MainMatchingPageState();
}

class _MainMatchingPageState extends State<MainMatchingPage> {
  late final SwipableStackController _controller;
  final MatchCardController _cardController = Get.put(MatchCardController());
  // late Function onCallPressed;
  late SocketService socketService;
  // final MatchingService matchingService = MatchingService();
  late StompClient client;
  String? uid;

  void _listenController() {
    setState(() {});
  }

  Future<void> initPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      uid = prefs.getString('uid');
      if (kDebugMode) {
        print(uid);
      }
    } catch (e) {
      debugPrint('Error retrieving values from SharedPreferences: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    socketService = widget
        .socketService!; // 얘를 생성하는 쪽(HomePage)의 socketService를 전달받아야 함. 전달이 제대로 안 됐다면 에러 나게 설정
    _controller = SwipableStackController()..addListener(_listenController);
    _cardController.onInit();
    initClient();
    initPrefs();
  }

  void initClient() async {
    client = await socketService
        .initSocket(); // socketService의 client를 static으로 설정했으므로, socketService 인스턴스가 여러개라도 얘는 기존에 있던 client를 받는다.
  }

  @override
  void dispose() {
    super.dispose();
    _controller
      ..removeListener(_listenController)
      ..dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SwipableStack(
                  detectableSwipeDirections: const {
                    SwipeDirection.right,
                    SwipeDirection.left,
                    SwipeDirection.up,
                    SwipeDirection.down,
                  },
                  controller: _controller,
                  stackClipBehaviour: Clip.none,
                  onSwipeCompleted: _onSwipe,
                  horizontalSwipeThreshold: 0.15,
                  verticalSwipeThreshold: 0.15,
                  builder: (context, properties) {
                    final itemIndex = properties.index % 2;
                    
                    return Stack(
                      children: [
                        MatchingCard(
                          matchingUser: MatchCardController.to
                              .getMatchingQue()
                              .value
                              .elementAt(itemIndex),
                        ),
                        if (properties.stackIndex == 0 &&
                            properties.direction != null)
                          CardOverlay(
                            swipeProgress: properties.swipeProgress,
                            direction: properties.direction!,
                          )
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // 매칭페이지의 call버튼 -> onLike() -> makeCall()을 통해 통화대기화면 이동까지만.
        heroTag: 'call',
        onPressed: () {
          if (uid == 'kS95PNT8RUc78Qr7TQ4uRaJmbw23') {
            // cebu13@gmail.com
            onLike('gHVcvjllueRTdd9F6P1M6ZUVi283'); //
          } else {
            onLike('kS95PNT8RUc78Qr7TQ4uRaJmbw23'); // perucebu13@gmail.com
          }
        },
        label: const Text('call'),
        icon: const Icon(Icons.call),
      ),
    );
  }

  void _onSwipe(int index, SwipeDirection direction) {
    if (direction == SwipeDirection.right) {
      // onLike(targetUid);
      // MatchCardController.to.removeCardProfile();
      debugPrint(
          "onLike ${MatchCardController.to.getMatchingQue().value.elementAt(index).nickname}, $direction}");
    } else if (direction == SwipeDirection.left) {
      // MatchCardController.to.removeCardProfile();
      debugPrint(
          "onDislike {${MatchCardController.to.getMatchingQue().value.elementAt(index).nickname}, $direction}");
    }
  }

  /// targetId = int

  Future<void> onLike(String targetUid) async {
    ChoiceRes? choiceRes;
    try {
      choiceRes = await postMatching(targetUid);
    } catch (exception) {
      print("exception = $exception");
      print("alert: 잘못된 요청");
      return;
    }
    if (choiceRes == null) {
      print("pending처리됨");
      return;
    }
    // when matched
    await socketService.makeCall(choiceRes.targetUid!); // callWaitingPage로 이동만.
  }
}
