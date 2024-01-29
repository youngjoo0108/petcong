import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:petcong/pages/app_pages/matching/dog_video.dart';
import 'package:petcong/widgets/matching_card.dart';

class SwipingPage extends StatefulWidget {
  const SwipingPage({super.key});

  @override
  State<SwipingPage> createState() => _SwipingPageState();
}

class _SwipingPageState extends State<SwipingPage> {
  final CardSwiperController controller = CardSwiperController();

  final cards = candidates.map(MatchingCard.new).toList();

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
                controller: controller,
                cardsCount: cards.length,
                onSwipe: _onSwipe,
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
            // ElevatedButton(
            //     onPressed: () {
            //       Get.to(WebRTC());
            //     },
            //     child: const Text('Call'))

            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       FloatingActionButton(
            //         onPressed: controller.undo,
            //         child: const Icon(Icons.rotate_left),
            //       ),
            //       FloatingActionButton(
            //         onPressed: controller.swipe,
            //         child: const Icon(Icons.rotate_right),
            //       ),
            //       FloatingActionButton(
            //         onPressed: controller.swipeLeft,
            //         child: const Icon(Icons.keyboard_arrow_left),
            //       ),
            //       FloatingActionButton(
            //         onPressed: controller.swipeRight,
            //         child: const Icon(Icons.keyboard_arrow_right),
            //       ),
            //       FloatingActionButton(
            //         onPressed: controller.swipeTop,
            //         child: const Icon(Icons.keyboard_arrow_up),
            //       ),
            //       FloatingActionButton(
            //         onPressed: controller.swipeBottom,
            //         child: const Icon(Icons.keyboard_arrow_down),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        heroTag: 'call',
        onPressed: () {
          Get.to(const MainDogVideos());
        },
        child: const Text('call'),
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
}
