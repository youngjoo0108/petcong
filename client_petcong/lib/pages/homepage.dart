import 'package:flutter/material.dart';
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/pages/app_pages/matching/matching_page.dart';
import 'package:petcong/services/socket_service.dart';
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
  OverlayEntry? _overlayEntry;

  final screens = [
    const MainChatPage(),
    const MainMatchingPage(),
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

//TODO: Resolve overlaying problem of this widget.

  void _showLogoutDropdown(BuildContext context) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 80,
          right: 8,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 150,
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
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Logout'),
                    onTap: () {
                      UserController.signOut();
                      _overlayEntry?.remove();
                      _overlayEntry = null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
}
