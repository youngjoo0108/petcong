import 'package:flutter/material.dart';
import 'package:petcong/models/candidate.dart';

class MatchingCard extends StatefulWidget {
  final ExampleCandidateModel candidate;

  const MatchingCard(
    this.candidate, {
    Key? key,
  }) : super(key: key);

  @override
  State<MatchingCard> createState() => _MatchingCardState();
}

class _MatchingCardState extends State<MatchingCard> {
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
              '${widget.candidate.name}, ${widget.candidate.age}',
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
              widget.candidate.description,
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
