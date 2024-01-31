import 'package:flutter/material.dart';
import 'package:petcong/widgets/continue_button.dart';

class IcebreakPage extends StatelessWidget {
  final double progress;

  const IcebreakPage({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, progress);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: LinearProgressIndicator(
            value: progress,
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 234, 64, 128),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 32),
                    onPressed: () => Navigator.pop(context, progress),
                  ),
                  TextButton(
                    child: const Text(
                      '건너뛰기',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey), // 여기에서 색상을 변경했습니다.
                    ),
                    onPressed: () {
                      // 다른 페이지로 이동하도록 수정해야 합니다.
                      // 예를 들어, 다음 페이지가 'NextPage'라면:
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage()));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Center(
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 234, 64, 128),
                    Color.fromARGB(255, 238, 128, 95),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: const Text(
                  '아이스 브레이커',
                  style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0), // 간격 추가
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0), // 원하는 여백으로 변경 가능합니다.
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '닉네임',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 수정 버튼 눌렀을 때 동작 설정
                    },
                    child: const Text('수정 >',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 20,
              color: Colors.grey,
              thickness: 0.2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0), // 원하는 여백으로 변경 가능합니다.
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '반려견 취미',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 수정 버튼 눌렀을 때 동작 설정
                    },
                    child: const Text('수정 >',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 20,
              color: Colors.grey,
              thickness: 0.2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0), // 원하는 여백으로 변경 가능합니다.
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '최애 간식',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 수정 버튼 눌렀을 때 동작 설정
                    },
                    child: const Text('수정 >',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 20,
              color: Colors.grey,
              thickness: 0.2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0), // 원하는 여백으로 변경 가능합니다.
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'DBTI',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 수정 버튼 눌렀을 때 동작 설정
                    },
                    child: const Text('수정 >',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                  ),
                ],
              ),
            ),

            const Divider(
              height: 20,
              color: Colors.grey,
              thickness: 0.2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0), // 원하는 여백으로 변경 가능합니다.
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '주소',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 추가 버튼 눌렀을 때 동작 설정
                    },
                    child: const Text('추가 >',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                  ),
                ],
              ),
            ),

            const Divider(
              height: 20,
              color: Colors.grey,
              thickness: 0.2,
            ), // 밑줄 추가
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0), // 원하는 여백으로 변경 가능합니다.
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '개인기',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 추가 버튼 눌렀을 때 동작 설정
                    },
                    child: const Text('추가 >',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                  ),
                ],
              ),
            ),

            const Divider(
              height: 20,
              color: Colors.grey,
              thickness: 0.2,
            ), // 밑줄 추가
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0), // 원하는 여백으로 변경 가능합니다.
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '몸무게',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 추가 버튼 눌렀을 때 동작 설정
                    },
                    child: const Text('추가 >',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                  ),
                ],
              ),
            ),

            const Divider(
              height: 20,
              color: Colors.grey,
              thickness: 0.2,
            ), // 밑줄 추가
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0), // 원하는 여백으로 변경 가능합니다.
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '크기',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 추가 버튼 눌렀을 때 동작 설정
                    },
                    child: const Text('추가 >',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                  ),
                ],
              ),
            ),

            const Divider(
              height: 20,
              color: Colors.grey,
              thickness: 0.2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0), // 원하는 여백으로 변경 가능합니다.
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '최애 장난감',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 추가 버튼 눌렀을 때 동작 설정
                    },
                    child: const Text('추가 >',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                  ),
                ],
              ),
            ),

            const Divider(
              height: 20,
              color: Colors.grey,
              thickness: 0.2,
            ),
            const SizedBox(height: 15.0),
            Center(
              child: Column(
                children: [
                  ContinueButton(
                    isFilled: true,
                    buttonText: 'CONTINUE',
                    onPressed: () {},
                    width: 240.0, // 원하는 가로 길이를 설정
                    height: 30.0, // 원하는 세로 길이를 설정
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
