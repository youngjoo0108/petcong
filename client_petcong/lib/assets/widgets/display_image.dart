import 'package:flutter/material.dart';
import 'dart:io';

// 이미지를 선택하고 화면에 표시되는 기능
class DisplayImage extends StatelessWidget {
  final String imagePath;

  const DisplayImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.file(File(imagePath));
  }
}
