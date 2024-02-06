import 'package:flutter/material.dart';

class MatchingCard extends StatefulWidget {
  const MatchingCard({
    required this.nickname,
    required this.description,
    required this.profileImages,
    required this.age,
    required this.petName,
    required this.petAge,
    super.key,
  });

  final String nickname;
  final int age;
  final String petName;
  final int petAge;
  final String description;
  final String profileImages;

  @override
  State<MatchingCard> createState() => _MatchingCardState();
}

class _MatchingCardState extends State<MatchingCard> {
  bool isPet = true;

  void onTap() {
    isPet = !isPet;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String humanProfile = "${widget.nickname}, ${widget.age}";
    final String petProfile = "${widget.petName}, ${widget.petAge}";
    return ClipRRect(
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: DecorationImage(
                  image: AssetImage(widget.profileImages),
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
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 191, 190, 190),
                      fontSize: 15,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 35),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
