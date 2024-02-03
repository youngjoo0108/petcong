import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:petcong/controller/chat_controller.dart';

class MainChatPage extends StatefulWidget {
  const MainChatPage({super.key});

  @override
  State<MainChatPage> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainChatPage> {
  int itemsCount = 20;
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500) * 5, () {
      if (!mounted) {
        return;
      }
      setState(() {
        itemsCount += 10;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LiveGrid(
          padding: const EdgeInsets.all(1),
          showItemInterval: const Duration(milliseconds: 50),
          showItemDuration: const Duration(milliseconds: 150),
          visibleFraction: 0.001,
          itemCount: itemsCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemBuilder: animationItemBuilder(
              (index) => HorizontalItem(title: index.toString())),
        ),
      ),
    );
  }
}
