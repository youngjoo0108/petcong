import 'package:flutter/material.dart';
import 'package:petcong/pages/app_pages/profile/pet_name_page.dart';

class MainProfilePage extends StatelessWidget {
  const MainProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Profile Page"),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PetNamePage()),
                  );
                },
                child: const Text('Go to write profile')),
          ],
        ),
      ),
    );
  }
}
