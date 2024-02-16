import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/pages/app_pages/matching/matching_page.dart';
import 'package:petcong/services/socket_service.dart';
import 'package:petcong/widgets/navigations.dart';
import 'package:petcong/pages/app_pages/chat/chat_page.dart';
import 'package:petcong/pages/app_pages/profile/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 1;
  final SocketService socketService =
      SocketService(); // State 객체가 하나 생성되고, socketService 인스턴스도 하나여야 하므로 final
  StompClient? _client;
  String? uid;
  OverlayEntry? _overlayEntry;

  late final screens;

  @override
  void initState() {
    super.initState();
    initPrefs();
    activateClient();
    screens = [
      const MainChatPage(),
      MainMatchingPage(
        socketService: socketService,
      ),
      const MainProfilePage(),
    ];
  }

  Future<void> initPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      uid = prefs.getString('uid');
      if (kDebugMode) {
        print("initPrefs: $uid");
      }
    } catch (e) {
      debugPrint('Error retrieving values from SharedPreferences: $e');
    }
  }

  Future<void> activateClient() async {
    await socketService.init();
    _client = await socketService.initSocket();
    debugPrint(_client.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 100, // 이미지의 너비 조절
          height: 30, // 이미지의 높이 조절
          child: Image.asset(
            'assets/src/가로형-사이즈맞춤.png',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showLogoutDropdown(context);
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

  void _showLogoutDropdown(BuildContext context) {
    if (_overlayEntry != null) {
      // Remove existing overlay entry
      _overlayEntry?.remove();
      _overlayEntry = null;
    } else {
      // Create new overlay entry
      Overlay.of(context).insert(
        _overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
            top: 80,
            right: 8,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.logout_outlined,
                      ),
                      title: const Text(
                        'Logout',
                        style: TextStyle(fontFamily: 'Cafe24', fontSize: 10),
                      ),
                      onTap: () async {
                        await UserController.signOut(uid!);
                        _overlayEntry?.remove();
                      },
                    ),
                    // ListTile(
                    //   leading: const Icon(Icons.exit_to_app),
                    //   title: const Text('탈퇴'),
                    //   onTap: () async {
                    //     // await UserController.signOut(_client, uid!);
                    //     await UserController.withdraw(uid!);
                    //     _overlayEntry?.remove();
                    //   },
                    // )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
