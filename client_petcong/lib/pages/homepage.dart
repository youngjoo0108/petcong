import 'package:flutter/material.dart';
import 'package:petcong/services/socket_service.dart';
import 'package:petcong/pages/app_pages/matching/swiping_page.dart';
import 'package:petcong/widgets/navigations.dart';
import 'package:petcong/pages/app_pages/chat/chat_page.dart';
import 'package:petcong/pages/app_pages/profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  late SocketService socketService;

  final screens = [
    const MainChatPage(),
    const SwipingPage(),
    // const MainMatchingPage(),
    const MainProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    socketService = SocketService();
    socketService.connectSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset(
            'assets/src/petcong_logo.png',
            fit: BoxFit.cover,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 여기 드롭바 해서 설정페이지 가거나 바로 프로필 설정 페이지로 이동
            },
          ),
        ],
      ),
      body: screens[currentIndex],
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: currentIndex,
        onItemTapped: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}
