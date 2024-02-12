import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:petcong/controller/chat_controller.dart';

class MainChatPage extends StatefulWidget {
  const MainChatPage({super.key});

  @override
  State<MainChatPage> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainChatPage> {
  int itemsCount = profiles.length;
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500) * 5, () {
      if (!mounted) {
        return;
      }
      setState(() {
        itemsCount += 6;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.8, // Adjust this value as needed
          children: List.generate(profiles.length, (index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            ProfileDetailPage(profile: profiles[index])));
              },
              child: ProfileCard(profile: profiles[index]),
            );
          }),
        ),
      ),
    );
  }
}

class Profile {
  final String name;
  final String description;
  final String imageUrl;
  final String instagram;
  final String kakaoId;

  Profile(
      this.name, this.description, this.imageUrl, this.instagram, this.kakaoId);
}

List<Profile> profiles = [
  Profile(
      'Name1', 'Description1', 'assets/src/test_1.jpg', 'instagram1', 'kakao1'),
  Profile(
      'Name2', 'Description2', 'assets/src/test_5.jpg', 'instagram2', 'kakao2'),
];

class ProfileCard extends StatelessWidget {
  final Profile profile;

  const ProfileCard({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Hero(
            tag: profile.imageUrl,
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset(profile.imageUrl, fit: BoxFit.cover),
            ),
          ),
          Text(profile.name, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class ProfileDetailPage extends StatelessWidget {
  final Profile profile;

  const ProfileDetailPage({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(profile.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: profile.imageUrl,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(profile.imageUrl, fit: BoxFit.cover),
              ),
            ),
            Text(profile.name, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text(profile.description),
            Text('Instagram: ${profile.instagram}'),
            Text('Kakao ID: ${profile.kakaoId}'),
          ],
        ),
      ),
    );
  }
}
