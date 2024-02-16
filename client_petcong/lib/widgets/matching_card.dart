import 'package:flutter/material.dart';
import 'package:petcong/models/card_profile_model.dart';

class MatchingCard extends StatefulWidget {
  final CardProfileModel matchingUser;

  const MatchingCard({Key? key, required this.matchingUser}) : super(key: key);

  @override
  State<MatchingCard> createState() => _MatchingCardState();
}

bool isPet = true;

void onTap() {
  isPet = !isPet;
}

class _MatchingCardState extends State<MatchingCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isMan = widget.matchingUser.gender == "MALE";
    final bool isMale = widget.matchingUser.petGender == "MALE";
    final String humanProfile =
        "${isMan ? "👨🏻" : "👩🏻"} ${widget.matchingUser.nickname}, ${widget.matchingUser.age}";
    final String petProfile =
        "${isMale ? "🐕" : "🐩"} ${widget.matchingUser.petName}, ${widget.matchingUser.petAge} ";
    return ClipRRect(
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: DecorationImage(
                  image:
                      NetworkImage(widget.matchingUser.profileImageUrls!.first),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 2),
                    blurRadius: 26,
                    color: Colors.black.withOpacity(0.08),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(14),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black12.withOpacity(0),
                    Colors.black12.withOpacity(.4),
                    Colors.black12.withOpacity(.82),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() {
              onTap();
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPet ? humanProfile : petProfile,
                    style: theme.textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cafe24',
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.matchingUser.description!,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 191, 190, 190),
                        fontSize: 15,
                        // fontFamily: 'Mulish',
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        fontFamily: 'Cafe24'),
                  ),
                  const SizedBox(height: 45),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
