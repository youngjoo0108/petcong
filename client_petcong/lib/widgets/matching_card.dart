import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  double xPosition = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            xPosition += details.delta.dx;
          });
        },
        onPanEnd: (details) {
          setState(() {
            xPosition = 0;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage(defaultImageSrc), fit: BoxFit.cover),
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
                top: 54,
                right: 36,
                child: _likeOrDislikeIconOnPhoto(
                  FontAwesomeIcons.ban,
                  Colors.redAccent,
                  xPosition < 0 ? xPosition.abs() / 100 : 0,
                ),
              ),
              Positioned(
                top: 50,
                left: 39,
                child: _likeOrDislikeIconOnPhoto(
                  FontAwesomeIcons.heart,
                  Colors.green,
                  xPosition > 0 ? xPosition / 100 : 0,
                ),
              ),
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
        ));
  }

  Widget _likeOrDislikeIconOnPhoto(
      IconData icon, Color iconColor, double opacityValue) {
    return AnimatedOpacity(
      opacity: opacityValue.clamp(0.0, 1.0), // 투명도가 0.0 ~ 1.0 사이가 되도록 보장
      duration: const Duration(milliseconds: 500),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 1.0,
            top: 2.0,
            child: FaIcon(
              icon,
              color: Colors.black54,
              size: 76,
            ),
          ),
          FaIcon(
            icon,
            color: iconColor,
            size: 76,
          ),
        ],
      ),
    );
  }
}
