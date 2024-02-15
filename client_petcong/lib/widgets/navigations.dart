import 'package:flutter/material.dart';
import 'package:petcong/constants/style.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  final int selectedIndex;
  final Function(int) onItemTapped;

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.star_rounded),
          label: 'Star',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/src/petcong_c_logo.png',
            width: 30,
            height: 30,
          ),
          label: 'PetCong',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'profile',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: MyColor.petCongColor4,
      onTap: widget.onItemTapped,
    );
  }
}
