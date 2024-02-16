import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:petcong/models/card_profile_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchedCard extends StatefulWidget {
  final CardProfileModel matchedUser;
  const MatchedCard({Key? key, required this.matchedUser}) : super(key: key);

  @override
  State<MatchedCard> createState() => _MatchedCardState();
}

class _MatchedCardState extends State<MatchedCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (kDebugMode) {
          print("matchedUser nickname onTap:}");
        }
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  ProfileDetailPage(matchedUser: widget.matchedUser)),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            Hero(
              tag: widget.matchedUser.profileImageUrls![0],
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: widget.matchedUser.profileImageUrls![0],
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.matchedUser.nickname,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Cafe24',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDetailPage extends StatefulWidget {
  final CardProfileModel matchedUser;

  const ProfileDetailPage({Key? key, required this.matchedUser})
      : super(key: key);

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.matchedUser.nickname,
          style: const TextStyle(fontFamily: 'Cafe24'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Hero(
                tag: widget.matchedUser.profileImageUrls![0],
                child: AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                        imageUrl: widget.matchedUser.profileImageUrls![0],
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover)),
              ),
              const SizedBox(height: 20),
              Text(
                widget.matchedUser.description!,
                style: const TextStyle(
                  fontFamily: 'Cafe24',
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Image.asset(
                      'assets/src/instagram_logo.png',
                      width: 40,
                    ),
                    onPressed: () async {
                      final url = Uri.parse(
                          'http://www.instagram.com/${widget.matchedUser.instagramId}');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch https://instagram.com/${widget.matchedUser.instagramId}}';
                      }
                    },
                  ),
                  Text(
                    '${widget.matchedUser.instagramId}',
                    style: const TextStyle(
                      fontFamily: 'Cafe24',
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Image.asset(
                      'assets/src/kakaotalk_logo.png',
                      width: 40,
                    ),
                    onPressed: () async {
                      final url = Uri.parse(
                          'http://www.instagram.com/${widget.matchedUser.instagramId}');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch https://instagram.com/${widget.matchedUser.instagramId}}';
                      }
                    },
                  ),
                  Text(
                    ' ${widget.matchedUser.kakaoId}',
                    style: const TextStyle(
                      fontFamily: 'Cafe24',
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
