import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcong/models/choice_res.dart';
import 'package:petcong/pages/app_pages/webRTC/webrtc.dart';
import 'package:petcong/services/socket_service.dart';
import 'package:petcong/services/matching_service.dart';
import 'package:petcong/widgets/card_overlay.dart';
import 'package:petcong/widgets/matching_card.dart';
import 'package:swipable_stack/swipable_stack.dart';

const _images = [
  'assets/src/dog.jpg',
  'assets/src/test_1.jpg',
  'assets/src/test_5.jpg',
];

const _names = ['하나', '둘리', '세르시'];

class MainMatchingPage extends StatefulWidget {
  const MainMatchingPage({Key? key}) : super(key: key);

  @override
  State<MainMatchingPage> createState() => _MainMatchingPageState();
}

class _MainMatchingPageState extends State<MainMatchingPage> {
  late final SwipableStackController _controller;

  void _listenController() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController()..addListener(_listenController);
  }

  @override
  void dispose() {
    super.dispose();
    _controller
      ..removeListener(_listenController)
      ..dispose();
  }

  // late Function onCallPressed;
  final SocketService socketService = SocketService();
  final MatchingService matchingService = MatchingService();

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
                  horizontalSwipeThreshold: 0.8,
                  verticalSwipeThreshold: 0.8,
                  builder: (context, properties) {
                    final itemIndex = properties.index % _images.length;
                    return Stack(
                      children: [
                        MatchingCard(
                          name: _names[itemIndex],
                          description: '난 너무 귀여워!',
                          profileImages: _images[itemIndex],
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
        heroTag: 'call',
        onPressed: () {
          socketService.onCallPressed('on');
        },
        label: const Text('call'),
        icon: const Icon(Icons.call),
      ),
    );
  }

  void _onSwipe(int index, SwipeDirection direction) {
    if (kDebugMode) {
      print('$index, $direction');
    }
  }

  /**
   * targetId = int
   */
  Future<void> onLike(int targetId) async {
    ChoiceRes? choiceRes;
    try {
      choiceRes = await matchingService.postMatching(targetId);
    } catch (exception) {
      // print("exception = " + exception.toString());
      print("alert: 잘못된 요청");
      return;
    }
    if (choiceRes == null) {
      print("pending처리됨");
      return;
    }
    // matched
    // 전화 오는 화면으로

    // 화면 띄워주면서, rtc 연결 시작
    await socketService.joinRoom();
    socketService.sendOffer(await socketService.initSocket()); // 바꾸기
  }
}
