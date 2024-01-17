import 'package:flutter/material.dart';
import 'package:petcong/assets/widgets/navigations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              'Content of Index $_selectedIndex',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MyBottomNavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
