// pet_name_page.dart
import 'package:flutter/material.dart';
import 'pet_birthday_page.dart';

class PetNamePage extends StatefulWidget {
  const PetNamePage({super.key});

  @override
  _PetNamePageState createState() => _PetNamePageState();
}

class _PetNamePageState extends State<PetNamePage> {
  final _controller = TextEditingController();
  bool _isButtonDisabled = true;
  double _progress = 3 / 10;

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
        leading: IconButton(
          icon: const Icon(Icons.close), // X 모양의 아이콘
          onPressed: () => Navigator.pop(context), // 버튼이 눌렸을 때 이전 페이지로 돌아감
        ),
        title: LinearProgressIndicator(value: _progress), // 상단 진행 상황 바
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const Text('내 반려동물 이름은?', style: TextStyle(fontSize: 24.0)), // 텍스트
            TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: '반려동물 이름을 입력하세요'),
            ),
            ElevatedButton(
              onPressed: _isButtonDisabled
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PetBirthdayPage(petName: _controller.text)),
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
