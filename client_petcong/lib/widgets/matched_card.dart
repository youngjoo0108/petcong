import 'package:flutter/material.dart';
import 'package:petcong/models/card_profile_model.dart';
import 'package:url_launcher/url_launcher.dart';

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
              child: Image.network(matchedUser.pictureUrls!.first,
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
                child: Image.network(matchedUser.pictureUrls!.first,
                    fit: BoxFit.cover),
              ),
            ),
            Text(matchedUser.nickname, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text(matchedUser.description!),
            const SizedBox(height: 10),
            IconButton(
              icon: const Icon(Icons.link),
              onPressed: () async {
                final url = Uri.parse(
                    'http://www.instagram.com/${matchedUser.instagramId}');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch https://instagram.com/${matchedUser.instagramId}}';
                }
              },
            ),
            const SizedBox(height: 10),
            Text('Kakao ID: ${matchedUser.kakaoId}'),
          ],
        ),
      ),
    );
  }
}
