import 'package:flutter/material.dart';
import 'package:petcong/constants/style.dart';
import 'package:petcong/services/socket_service.dart';

class CallWaiting extends StatelessWidget {
  const CallWaiting({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        // body: Center(
        //   child: ElevatedButton(
        //     onPressed: () {
        //       SocketService().startCamera();
        //     },
        //     child: const Text('call'),
        //   ),
        // ),
        // bottomNavigationBar: ClipRRect(
        //   borderRadius: const BorderRadius.only(
        //       topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        //   child: BottomNavigationBar(
        //     showSelectedLabels: false,
        //     showUnselectedLabels: false,
        //     backgroundColor: MyColor.myColor4.withOpacity(0.8),
        //     items: const <BottomNavigationBarItem>[
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.call),
        //         label: 'call',
        //       ),
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.call_end),
        //         label: 'reject',
        //       ),
        //     ],
        //   ),
        // ),
        // body: FloatingActionButtonLocation.startDocked,
        );
  }
}
