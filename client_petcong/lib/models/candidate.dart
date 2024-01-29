import 'package:flutter/material.dart';

class ExampleCandidateModel {
  final String name;
  final int age;
  final String description;
  final List<Image> images;

  ExampleCandidateModel({
    required this.name,
    required this.age,
    required this.description,
    required this.images,
  });
}

const String defaultImageSrc = 'assets/src/dog.jpg';
Image defaultImages = Image.asset(defaultImageSrc);

final List<ExampleCandidateModel> candidates = [
  ExampleCandidateModel(
    name: '하나둘셋',
    age: 3,
    description: '내 강아지는 귀여워용',
    images: [defaultImages],
  ),
  ExampleCandidateModel(
    name: '둘이둘이',
    age: 5,
    description: '내 강아지는 귀여워용',
    images: [defaultImages],
  ),
  ExampleCandidateModel(
    name: '석삼이',
    age: 32,
    description: '내 강아지는 귀여워용',
    images: [defaultImages],
  ),
  ExampleCandidateModel(
    name: '넉살이',
    age: 11,
    description: '내 강아지는 귀여워용',
    images: [defaultImages],
  ),
];
