// nickname_page.dart
import 'package:flutter/material.dart';
import 'birthday_page.dart'; // BirthdayPage를 import

class NicknamePage extends StatefulWidget {
  const NicknamePage({super.key});

  @override
  _NicknamePageState createState() => _NicknamePageState();
}

class _NicknamePageState extends State<NicknamePage> {
  final _controller = TextEditingController();
  bool _isButtonDisabled = true;
  double _progress = 0;

  void _increaseProgress() {
    setState(() {
      _progress += 1 / 10; // 진행 상황을 증가시킴
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isButtonDisabled = _controller.text.trim().isEmpty;
        if (!_isButtonDisabled) {
          _increaseProgress(); // 텍스트 필드가 비어있지 않다면 진행 상황 증가
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LinearProgressIndicator(value: _progress), // 상단 진행 상황 바
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const Text('내 별명은?', style: TextStyle(fontSize: 24.0)), // 텍스트
            TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: '별명을 입력하세요'),
            ),
            ElevatedButton(
              onPressed: _isButtonDisabled
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const BirthdayPage()), // 생일 입력 페이지로 이동
                      );
                    },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
