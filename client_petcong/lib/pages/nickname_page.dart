import 'package:flutter/material.dart';
import 'birthday_page.dart';

class NicknamePage extends StatefulWidget {
  const NicknamePage({Key? key}) : super(key: key);

  @override
  _NicknamePageState createState() => _NicknamePageState();
}

class _NicknamePageState extends State<NicknamePage> {
  final _controller = TextEditingController();
  bool _isButtonDisabled = true;
  double _progress = 0;

  void _increaseProgress() {
    setState(() {
      _progress += 1 / 10;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isButtonDisabled = _controller.text.trim().isEmpty;
        if (!_isButtonDisabled) {
          _increaseProgress();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LinearProgressIndicator(value: _progress),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const Text('내 별명은?', style: TextStyle(fontSize: 24.0)),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '별명을 입력하세요',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _isButtonDisabled
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BirthdayPage(),
                        ),
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
