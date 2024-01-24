import 'package:flutter/material.dart';
import 'birthday_page.dart';
import 'profile_page.dart'; // ProfilePage를 import 해주세요.
import 'package:petcong/widgets/continue_button.dart';

class NicknamePage extends StatefulWidget {
  final double progress;

  const NicknamePage({Key? key, required this.progress}) : super(key: key);

  @override
  _NicknamePageState createState() => _NicknamePageState();
}

class _NicknamePageState extends State<NicknamePage> {
  final _controller = TextEditingController();
  bool _isButtonDisabled = true;
  double _progress = 0.0; // _progress 변수를 추가하여 초기화합니다.

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isButtonDisabled = _controller.text.trim().isEmpty;
      });
    });
    _progress = widget.progress; // progress 값을 _progress에 할당합니다.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: LinearProgressIndicator(
          value: _progress,
          valueColor: const AlwaysStoppedAnimation<Color>(
            Color.fromARGB(255, 234, 64, 128),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.close, size: 32),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const MainProfilePage(), // MainProfilePage로 이동하도록 수정
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10.0),
            const Text('내 별명은?', style: TextStyle(fontSize: 40.0)),
            const SizedBox(height: 50.0),
            SizedBox(
              width: 300, // 원하는 너비 설정
              child: TextField(
                controller: _controller,
                style: const TextStyle(
                  fontSize: 20.0,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal,
                ),
                decoration: const InputDecoration(
                  hintText: '별명을 입력하세요',
                  border: InputBorder.none,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            ContinueButton(
              isFilled: !_isButtonDisabled,
              buttonText: 'Continue',
              onPressed: !_isButtonDisabled
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BirthdayPage(
                            progress: widget.progress + 1 / 10,
                          ),
                        ),
                      );
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
