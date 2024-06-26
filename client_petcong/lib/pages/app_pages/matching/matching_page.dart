import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcong/controller/call_wait_controller.dart';
import 'package:petcong/controller/match_card_controller.dart';
import 'package:petcong/models/card_profile_model.dart';
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
    socketService.initRTCWidget();
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
                  // itemCount: 3,
                  builder: (context, properties) {
                    final itemIndex = properties.index % 10;
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
      // floatingActionButton: FloatingActionButton.extended(
      //   // 매칭페이지의 call버튼 -> onLike() -> makeCall()을 통해 통화대기화면 이동까지만.
      //   heroTag: 'call',
      //   onPressed: () {
      //     if (uid == '4GtzqrsSDBVSC1FkOWXXJ2i7CfA3') {
      //       onLike(187); // 패드
      //     } else {
      //       onLike(147); // 여기에 쓰면 됨
      //     }
      //   },
      //   label: const Text('call'),
      //   icon: const Icon(Icons.call),
      // ),
    );
  }

  void _onSwipe(int index, SwipeDirection direction) {
    if (direction == SwipeDirection.right) {
      onLike(MatchCardController.to
          .getMatchingQue()
          .value
          .elementAt(index)
          .memberId);
      // MatchCardController.to.removeCardProfile();
      debugPrint(
          "onLike ${MatchCardController.to.getMatchingQue().value.elementAt(index).nickname}, $direction}");
    } else if (direction == SwipeDirection.left) {
      // MatchCardController.to.removeCardProfile();
      debugPrint(
          "onDislike {${MatchCardController.to.getMatchingQue().value.elementAt(index).nickname}, $direction}");
    }
    // MatchCardController.to.fillQueue();
  }

  Future<void> onLike(int targetId) async {
    CardWaitController cardWaitController = Get.put(CardWaitController());
    CardProfileModel? targetUserInfo;
    String? targetUid;
    try {
      Map<String, dynamic>? response = await postMatching(targetId);
      if (response != null) {
        targetUserInfo = response['profile'];
        targetUid = response['targetUid'];
        cardWaitController.setCardProfile(targetUserInfo!);
      }
    } catch (exception) {
      if (kDebugMode) {
        print("exception = $exception");
        print("alert: 잘못된 요청");
      }
      return;
    }
    // when matched

    if (targetUserInfo != null) {
      // 로직 변경될 부분 ----
      await socketService.makeCall(targetUid!); // callWaitingPage로 이동만.

      // ---- /
    }
  }
}
