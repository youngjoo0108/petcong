// gender_page.dart
import 'package:flutter/material.dart';
import 'pet_name_page.dart';

class GenderPage extends StatefulWidget {
  const GenderPage({Key? key}) : super(key: key);

  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  String _gender = ''; // 선택된 성별을 저장하는 상태
  double _progress = 2 / 10; // 진행 상황을 나타내는 상태

  void _increaseProgress() {
    setState(() {
      _progress += 1 / 10; // 진행 상황을 최대로 증가
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
        child: Column(
          children: <Widget>[
            const Text('성별을 선택하세요', style: TextStyle(fontSize: 24.0)), // 텍스트
            ListTile(
              title: const Text('여자예요'),
              leading: Radio(
                value: '여자',
                groupValue: _gender,
                onChanged: (String? value) {
                  setState(() {
                    _gender = value!;
                    _increaseProgress(); // 성별을 선택하면 진행 상황 증가
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('남자예요'),
              leading: Radio(
                value: '남자',
                groupValue: _gender,
                onChanged: (String? value) {
                  setState(() {
                    _gender = value!;
                    _increaseProgress(); // 성별을 선택하면 진행 상황 증가
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: _gender.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PetNamePage()),
                      );
                    },
              child: const Text('계속하기'),
            ),
          ],
        ),
      ),
    );
  }
}
