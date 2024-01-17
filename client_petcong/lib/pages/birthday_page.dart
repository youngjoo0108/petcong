// birthday_page.dart
import 'package:flutter/material.dart';
import 'gender_page.dart'; // GenderPage를 import

class BirthdayPage extends StatefulWidget {
  const BirthdayPage({super.key});

  @override
  _BirthdayPageState createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  double _progress = 1 / 10; // 진행 상황을 나타내는 상태

  void _increaseProgress() {
    setState(() {
      _progress += 1 / 10; // 진행 상황을 증가
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.text.trim().isNotEmpty) {
        _increaseProgress(); // 텍스트 필드가 비어있지 않다면 진행 상황 증가
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // < 모양의 아이콘
          onPressed: () => Navigator.pop(context), // 버튼이 눌렸을 때 이전 페이지로 돌아감
        ),
        title: LinearProgressIndicator(value: _progress), // 상단 진행 상황 바
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Text('내 생일은?', style: TextStyle(fontSize: 24.0)), // 텍스트
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'YYYY/MM/DD'),
                validator: (value) {
                  return null;
                },
              ),
              ElevatedButton(
                child: const Text('Continue'),
                onPressed: () {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const GenderPage()), // 성별 선택 페이지로 이동
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
