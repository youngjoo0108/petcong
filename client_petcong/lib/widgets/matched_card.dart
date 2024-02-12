import 'package:flutter/material.dart';
import 'package:petcong/models/card_profile_model.dart';

class MatchedCard extends StatelessWidget {
  final CardProfileModel matchedUser;

  const MatchedCard({Key? key, required this.matchedUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Hero(
            tag: matchedUser.pictureUrls!.first,
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset(matchedUser.pictureUrls!.first,
                  fit: BoxFit.cover),
            ),
          ),
          Text(matchedUser.pictureUrls!.first,
              style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class ProfileDetailPage extends StatelessWidget {
  final CardProfileModel matchedUser;

  const ProfileDetailPage({Key? key, required this.matchedUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(matchedUser.nickname),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: matchedUser.pictureUrls!.first,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(matchedUser.pictureUrls!.first,
                    fit: BoxFit.cover),
              ),
            ),
            Text(matchedUser.nickname, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text(matchedUser.description!),
            const SizedBox(height: 10),
            Text('Instagram: ${matchedUser.instagramId}'),
            const SizedBox(height: 10),
            Text('Kakao ID: ${matchedUser.kakaoId}'),
          ],
        ),
      ),
    );
  }
}
