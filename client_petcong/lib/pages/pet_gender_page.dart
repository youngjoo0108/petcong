import 'package:flutter/material.dart';
import 'introduce_page.dart';

class PetGenderPage extends StatefulWidget {
  final String petName;

  const PetGenderPage({required this.petName, Key? key}) : super(key: key);

  @override
  _PetGenderPageState createState() => _PetGenderPageState();
}

class _PetGenderPageState extends State<PetGenderPage> {
  String _gender = ''; // 선택된 성별을 저장하는 상태
  bool _isNeutered = false; // 중성화 여부를 저장하는 상태
  double _progress = 5 / 10; // 진행 상황을 나타내는 상태

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
            Text('${widget.petName}의 성별을 선택하세요',
                style: const TextStyle(fontSize: 24.0)), // 텍스트
            ElevatedButton(
              onPressed: _isNeutered
                  ? null
                  : () {
                      setState(() {
                        _gender = 'FEMALE';
                        _increaseProgress(); // 성별을 선택하면 진행 상황 증가
                      });
                    },
              child: const Text('FEMALE'),
            ),
            ElevatedButton(
              onPressed: _isNeutered
                  ? null
                  : () {
                      setState(() {
                        _gender = 'MALE';
                        _increaseProgress(); // 성별을 선택하면 진행 상황 증가
                      });
                    },
              child: const Text('MALE'),
            ),
            CheckboxListTile(
              title: const Text('중성화했어요'),
              value: _isNeutered,
              onChanged: _gender.isEmpty
                  ? null
                  : (bool? value) {
                      setState(() {
                        _isNeutered = value!;
                        _increaseProgress(); // 체크박스를 선택하면 진행 상황 증가
                      });
                    },
            ),
            ElevatedButton(
              onPressed: _gender.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const IntroducePage()),
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
