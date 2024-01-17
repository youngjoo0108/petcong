import 'package:flutter/material.dart';
import 'package:petcong/assets/widgets/navigations.dart';
import 'package:petcong/pages/app_pages/chat/chat_page.dart';
import 'package:petcong/pages/app_pages/matching/matching_page.dart';
import 'package:petcong/pages/app_pages/profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final screens = [
    const MainChatPage(),
    const MainMatchingPage(),
    const MainProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: screens[currentIndex],
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: currentIndex,
        onItemTapped: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}
