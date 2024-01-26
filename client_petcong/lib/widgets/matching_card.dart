import 'package:flutter/material.dart';

class ExampleCandidateModel {
  final String name;
  final int age;
  final String description;
  final List<Color> color;
  final List<Image> images;

  ExampleCandidateModel({
    required this.name,
    required this.age,
    required this.description,
    required this.color,
    required this.images,
  });
}

const String defaultImageSrc = 'assets/src/dog.jpg';
Image defaultImages = Image.asset(defaultImageSrc);

final List<ExampleCandidateModel> candidates = [
  ExampleCandidateModel(
    name: 'One',
    age: 3,
    description: '내 강아지는 귀여워용',
    color: const [Color(0xFFFF3868), Color(0xFFFFB49A)],
    images: [defaultImages],
  ),
  ExampleCandidateModel(
    name: 'Two',
    age: 5,
    description: '내 강아지는 귀여워용',
    color: const [Color(0xFF736EFE), Color(0xFF62E4EC)],
    images: [defaultImages],
  ),
  ExampleCandidateModel(
    name: 'Three',
    age: 21,
    description: '내 강아지는 귀여워용',
    color: const [Color(0xFF2F80ED), Color(0xFF56CCF2)],
    images: [defaultImages],
  ),
  ExampleCandidateModel(
    name: 'Four',
    age: 11,
    description: '내 강아지는 귀여워용',
    color: const [Color(0xFF0BA4E0), Color(0xFFA9E4BD)],
    images: [defaultImages],
  ),
];

class MatchingCard extends StatelessWidget {
  final ExampleCandidateModel candidate;

  const MatchingCard(
    this.candidate, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage(defaultImageSrc),
            // image: NetworkImage('https://picsum.photos/536/354'),
            fit: BoxFit.cover),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.bottomLeft,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 409,
            child: Container(
              width: 380,
              height: 277,
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(0.00, -1.00),
                  end: const Alignment(0, 1),
                  colors: [Colors.black.withOpacity(0), Colors.black],
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(11),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 11,
            top: 509,
            child: Text(
              '${candidate.name}, ${candidate.age}',
              style: const TextStyle(
                color: Color(0xFFFCFCFC),
                fontSize: 37,
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w700,
                height: 0.01,
              ),
            ),
          ),
          Positioned(
            left: 14,
            top: 553,
            child: Text(
              candidate.description,
              style: const TextStyle(
                color: Color(0xFFFCFCFC),
                fontSize: 16,
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w400,
                height: 0.03,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
