import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcong/constants/style.dart';
import 'package:petcong/controller/history_controller.dart';
import 'package:petcong/models/card_profile_model.dart';
import 'package:petcong/widgets/matched_card.dart';

class MainChatPage extends StatefulWidget {
  const MainChatPage({super.key});
  @override
  State<MainChatPage> createState() => MainChatPageState();
}

class MainChatPageState extends State<MainChatPage> {
  @override
  Widget build(BuildContext context) {
    Get.put(HistoryController());

    HistoryController.to.getMatchedUsers();
    RxList<CardProfileModel> matchedUsers = HistoryController.to.matchedUsers;
    if (matchedUsers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/src/waiting.png'),
              const SizedBox(height: 20),
              const Text(
                '아직 매칭된 상대가 없습니다.',
                style: TextStyle(
                    fontFamily: 'Cafe24',
                    color: MyColor.myColor2,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              const Text(
                '매칭 상대를 찾아보세요!',
                style: TextStyle(
                    fontFamily: 'Cafe24',
                    color: MyColor.myColor2,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: SafeArea(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            children: List.generate(matchedUsers.length, (index) {
              return MatchedCard(matchedUser: matchedUsers[index]);
            }),
          ),
        ),
      );
    }
  }
}
