import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:petcong/models/candidate.dart';
import 'package:petcong/pages/app_pages/webRTC/webrtc.dart';
import 'package:petcong/pages/homepage.dart';
import 'package:petcong/widgets/matching_card.dart';
import 'package:stomp_dart_client/stomp.dart';

GlobalKey _key = GlobalKey();

class SwipingPage extends StatefulWidget {
  const SwipingPage({super.key});

  // final StompClient client;
  // const SwipingPage({Key? key, required this.client}) : super(key: key);

  @override
  State<SwipingPage> createState() => _SwipingPageState();
}

class _SwipingPageState extends State<SwipingPage> {
  final CardSwiperController controller = CardSwiperController();
  final cards = candidates.map(MatchingCard.new).toList();
  late Function onCallPressed;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: CardSwiper(
                key: _key,
                controller: controller,
                cardsCount: cards.length,
                onSwipe: _onSwipe,
                onSwipeDirectionChange: _onSwipeDirectionChange,
                onUndo: _onUndo,
                numberOfCardsDisplayed: 2,
                backCardOffset: const Offset(0, 0),
                padding: const EdgeInsets.all(2.0),
                cardBuilder: (
                  context,
                  index,
                  horizontalThresholdPercentage,
                  verticalThresholdPercentage,
                ) =>
                    cards[index],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'call',
        onPressed: () {
          Get.to(() => const MainVideoCallWidget());
          // onCallPressed;
        },
        label: const Text('call'),
        icon: const Icon(Icons.call),
      ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );

    debugPrint('This card ${candidates[previousIndex].name}');
    setState(() {});

    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $currentIndex was undod from the ${direction.name}',
    );
    return true;
  }

  void _onSwipeDirectionChange(CardSwiperDirection horizontalDirection,
      CardSwiperDirection verticalDirection) {
    debugPrint(
      'The horizontal direction is $horizontalDirection and the vertical direction is $verticalDirection',
    );
  }
}
