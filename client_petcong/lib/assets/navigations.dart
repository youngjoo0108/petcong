import 'package:flutter/material.dart';
import 'package:petcong/assets/style.dart';

Widget bottomNavigationBar() {
  int selectedIndex = 0;
  TextStyle optionStyle = const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );
  List<Widget> widgetOptions = <Widget>[
    Text(
      'Index 0: Star',
      style: optionStyle,
    ),
    Text(
      'Index 1: Search',
      style: optionStyle,
    ),
    Text(
      'Index 2: Main',
      style: optionStyle,
    ),
    Text(
      'Index 3: Chat',
      style: optionStyle,
    ),
    Text(
      'Index 4: Profile',
      style: optionStyle,
    ),
  ];

  void onItemTapped(int index) {
    // Your existing code for handling item tap
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      widgetOptions.elementAt(selectedIndex),
      BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.star_rounded),
            label: 'Star',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.space_dashboard_rounded),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel_class_rounded),
            label: 'main',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            label: 'chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'profile',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: MyColor.myColor2,
        onTap: onItemTapped,
      ),
    ],
  );
}
