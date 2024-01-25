import 'package:flutter/material.dart';

class MyColor {
  static const Color myColor1 = Color.fromRGBO(255, 190, 152, 1);
  static const Color myColor2 = Color.fromRGBO(238, 128, 95, 1);
  static const Color myColor3 = Color.fromRGBO(217, 90, 69, 1);
  static const Color myColor4 = Color.fromRGBO(249, 113, 95, 1);
  static const Color myColor5 = Color.fromRGBO(234, 64, 128, 1);

  static Widget getGradientContainer() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            myColor3,
            myColor2,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

class MyTextStyle {
  static const String koreanFontFamily = 'Inter'; // 한글 폰트 패밀리
  static const String englishFontFamily = 'Mulish'; // 영어 폰트 패밀리

  static const TextStyle myTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static TextStyle getAutoFontStyle(String text) {
    // 한글이 포함되어 있으면 한글 폰트, 그 외에는 영어 폰트 사용
    if (containsKorean(text)) {
      return myTextStyle.copyWith(fontFamily: koreanFontFamily);
    } else {
      return myTextStyle.copyWith(fontFamily: englishFontFamily);
    }
  }

  static bool containsKorean(String text) {
    // 정규 표현식을 사용하여 문자열에 한글이 포함되어 있는지 확인
    final RegExp koreanRegExp = RegExp(r'[가-힣]');
    return koreanRegExp.hasMatch(text);
  }
}
